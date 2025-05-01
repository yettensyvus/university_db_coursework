-- create_triggers.sql
-- Defines triggers for the database

CREATE TRIGGER trg_update_students_updated_at
BEFORE UPDATE ON administrative.students
FOR EACH ROW EXECUTE FUNCTION administrative.update_updated_at_trigger();

CREATE TRIGGER trg_update_student_records_updated_at
BEFORE UPDATE ON administrative.student_records
FOR EACH ROW EXECUTE FUNCTION administrative.update_updated_at_trigger();

CREATE TRIGGER trg_update_course_enrollments_updated_at
BEFORE UPDATE ON administrative.course_enrollments_partitioned
FOR EACH ROW EXECUTE FUNCTION administrative.update_updated_at_trigger();

CREATE TRIGGER trg_update_grades_updated_at
BEFORE UPDATE ON administrative.grades
FOR EACH ROW EXECUTE FUNCTION administrative.update_updated_at_trigger();

CREATE TRIGGER trg_update_invoices_updated_at
BEFORE UPDATE ON financial.invoices
FOR EACH ROW EXECUTE FUNCTION administrative.update_updated_at_trigger();

-- First define the function before creating the trigger that uses it
CREATE OR REPLACE FUNCTION administrative.update_final_grade_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_final_grade NUMERIC(4,2);
    v_course_credits INT;
    v_student_id INT;
    v_course_id INT;
BEGIN
    v_final_grade := administrative.calculate_final_grade(NEW.enrollment_id);
    
    UPDATE administrative.course_enrollments_partitioned
    SET final_grade = v_final_grade,
        updated_at = CURRENT_TIMESTAMP
    WHERE enrollment_id = NEW.enrollment_id;
    
    SELECT student_id, course_id INTO v_student_id, v_course_id
    FROM administrative.course_enrollments_partitioned
    WHERE enrollment_id = NEW.enrollment_id;
    
    UPDATE administrative.course_enrollments_partitioned
    SET status = CASE 
                    WHEN v_final_grade >= 5 THEN 'Completed'
                    WHEN v_final_grade < 5 THEN 'Failed'
                    ELSE status
                 END,
        updated_at = CURRENT_TIMESTAMP
    WHERE enrollment_id = NEW.enrollment_id
      AND status = 'Enrolled'
      AND v_final_grade IS NOT NULL;
      
    IF (SELECT status FROM administrative.course_enrollments_partitioned WHERE enrollment_id = NEW.enrollment_id) = 'Completed' THEN
        SELECT credits INTO v_course_credits
        FROM academic.courses
        WHERE course_id = v_course_id;
        
        UPDATE administrative.student_records
        SET credits_earned = credits_earned + v_course_credits,
            updated_at = CURRENT_TIMESTAMP
        WHERE student_id = v_student_id
          AND NOT EXISTS (
            SELECT 1 FROM administrative.course_enrollments 
            WHERE student_id = v_student_id 
              AND course_id = v_course_id
              AND status = 'Completed'
              AND enrollment_id != NEW.enrollment_id
          );
          
        UPDATE administrative.student_records
        SET gpa = administrative.calculate_student_gpa(v_student_id),
            updated_at = CURRENT_TIMESTAMP
        WHERE student_id = v_student_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_final_grade
AFTER INSERT OR UPDATE OF grade, percentage ON administrative.grades
FOR EACH ROW EXECUTE FUNCTION administrative.update_final_grade_trigger();

-- Define function before its trigger
CREATE OR REPLACE FUNCTION financial.update_invoice_status_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_invoice_total NUMERIC(10,2);
    v_paid_total NUMERIC(10,2);
BEGIN
    SELECT total_amount INTO v_invoice_total
    FROM financial.invoices
    WHERE invoice_id = NEW.invoice_id;
    
    SELECT COALESCE(SUM(amount), 0) INTO v_paid_total
    FROM financial.payments
    WHERE invoice_id = NEW.invoice_id
      AND status = 'Completed';
    
    IF v_paid_total >= v_invoice_total THEN
        UPDATE financial.invoices
        SET status = 'Paid',
            updated_at = CURRENT_TIMESTAMP
        WHERE invoice_id = NEW.invoice_id;
    ELSIF v_paid_total > 0 THEN
        UPDATE financial.invoices
        SET status = 'Partially Paid',
            updated_at = CURRENT_TIMESTAMP
        WHERE invoice_id = NEW.invoice_id
          AND status != 'Paid';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_invoice_status
AFTER INSERT OR UPDATE ON financial.payments
FOR EACH ROW EXECUTE FUNCTION financial.update_invoice_status_trigger();

-- Define function before its trigger
CREATE OR REPLACE FUNCTION financial.create_installments_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_installment_amount NUMERIC(10,2);
    v_due_date DATE;
    i INT;
BEGIN
    v_installment_amount := ROUND(NEW.total_amount / NEW.number_of_installments, 2);
    
    FOR i IN 1..NEW.number_of_installments LOOP
        v_due_date := NEW.start_date + ((i-1) * INTERVAL '1 month');
        
        IF i = NEW.number_of_installments THEN
            v_installment_amount := NEW.total_amount - (v_installment_amount * (NEW.number_of_installments - 1));
        END IF;
        
        INSERT INTO financial.installments (
            plan_id, 
            installment_number, 
            due_date, 
            amount, 
            status
        ) VALUES (
            NEW.plan_id, 
            i, 
            v_due_date, 
            v_installment_amount, 
            'Pending'
        );
    END LOOP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_create_installments
AFTER INSERT ON financial.payment_plans
FOR EACH ROW EXECUTE FUNCTION financial.create_installments_trigger();

-- Define function before its trigger
CREATE OR REPLACE FUNCTION financial.update_installment_status_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_plan_id INT;
    v_invoice_id INT;
BEGIN
    SELECT invoice_id INTO v_invoice_id
    FROM financial.payments
    WHERE payment_id = NEW.payment_id;
    
    SELECT plan_id INTO v_plan_id
    FROM financial.payment_plans
    WHERE invoice_id = v_invoice_id;
    
    IF v_plan_id IS NOT NULL THEN
        WITH unpaid_installment AS (
            SELECT installment_id
            FROM financial.installments
            WHERE plan_id = v_plan_id
              AND status = 'Pending'
            ORDER BY due_date
            LIMIT 1
        )
        UPDATE financial.installments
        SET status = 'Paid',
            payment_id = NEW.payment_id,
            updated_at = CURRENT_TIMESTAMP
        FROM unpaid_installment
        WHERE installments.installment_id = unpaid_installment.installment_id;
        
        IF NOT EXISTS (
            SELECT 1 
            FROM financial.installments 
            WHERE plan_id = v_plan_id 
              AND status != 'Paid'
        ) THEN
            UPDATE financial.payment_plans
            SET status = 'Completed',
                updated_at = CURRENT_TIMESTAMP
            WHERE plan_id = v_plan_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_installment_status
AFTER INSERT ON financial.payments
FOR EACH ROW EXECUTE FUNCTION financial.update_installment_status_trigger();

-- Define function before its trigger
CREATE OR REPLACE FUNCTION administrative.check_overdue_courses_trigger()
RETURNS TRIGGER AS $$
DECLARE
    current_academic_year VARCHAR(9);
    current_semester INT;
BEGIN
    -- Calculate current academic year (format: YYYY-YYYY)
    current_academic_year := 
        CASE 
            WHEN EXTRACT(MONTH FROM CURRENT_DATE) <= 8 THEN 
                (EXTRACT(YEAR FROM CURRENT_DATE) - 1) || '-' || EXTRACT(YEAR FROM CURRENT_DATE)
            ELSE 
                EXTRACT(YEAR FROM CURRENT_DATE) || '-' || (EXTRACT(YEAR FROM CURRENT_DATE) + 1)
        END;
    
    -- Calculate current semester (1 = Sep-Jan, 2 = Feb-Jun)
    current_semester := 
        CASE 
            WHEN EXTRACT(MONTH FROM CURRENT_DATE) BETWEEN 9 AND 12 OR 
                 EXTRACT(MONTH FROM CURRENT_DATE) = 1 THEN 1
            WHEN EXTRACT(MONTH FROM CURRENT_DATE) BETWEEN 2 AND 6 THEN 2
            ELSE NULL -- Summer break
        END;
    
    -- Only mark as overdue if we're in an active semester
    IF current_semester IS NOT NULL THEN
        UPDATE administrative.course_enrollments_partitioned
        SET status = 'Overdue',
            updated_at = CURRENT_TIMESTAMP
        WHERE status = 'Enrolled'
          AND (
              -- Previous academic years
              academic_year < current_academic_year
              OR 
              -- Same academic year but previous semester
              (academic_year = current_academic_year AND semester < current_semester)
          );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION administrative.log_audit_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO administrative.audit_logs (
            table_name, 
            operation, 
            user_name, 
            old_data, 
            changed_by_role,
            changed_by_user_id
        ) VALUES (
            TG_TABLE_NAME, 
            TG_OP, 
            current_user, 
            to_jsonb(OLD),
            current_setting('role', true),
            current_setting('user_id', true)::int
        );
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO administrative.audit_logs (
            table_name, 
            operation, 
            user_name, 
            old_data, 
            new_data,
            changed_by_role,
            changed_by_user_id
        ) VALUES (
            TG_TABLE_NAME, 
            TG_OP, 
            current_user, 
            to_jsonb(OLD),
            to_jsonb(NEW),
            current_setting('role', true),
            current_setting('user_id', true)::int
        );
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO administrative.audit_logs (
            table_name, 
            operation, 
            user_name, 
            new_data,
            changed_by_role,
            changed_by_user_id
        ) VALUES (
            TG_TABLE_NAME, 
            TG_OP, 
            current_user, 
            to_jsonb(NEW),
            current_setting('role', true),
            current_setting('user_id', true)::int
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_overdue_courses
AFTER INSERT OR UPDATE ON administrative.course_enrollments_partitioned
FOR EACH ROW EXECUTE FUNCTION administrative.check_overdue_courses_trigger();

CREATE TRIGGER audit_students_changes
AFTER INSERT OR UPDATE OR DELETE ON administrative.students
FOR EACH ROW EXECUTE FUNCTION administrative.log_audit_changes();

CREATE TRIGGER audit_grades_changes
AFTER INSERT OR UPDATE OR DELETE ON administrative.grades
FOR EACH ROW EXECUTE FUNCTION administrative.log_audit_changes();

CREATE TRIGGER audit_invoices_changes
AFTER INSERT OR UPDATE OR DELETE ON financial.invoices
FOR EACH ROW EXECUTE FUNCTION administrative.log_audit_changes();

CREATE TRIGGER audit_payments_changes
AFTER INSERT OR UPDATE OR DELETE ON financial.payments
FOR EACH ROW EXECUTE FUNCTION administrative.log_audit_changes();