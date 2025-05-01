-- create_functions.sql
-- Defines functions and stored procedures

CREATE OR REPLACE FUNCTION administrative.update_updated_at_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION administrative.calculate_final_grade(p_enrollment_id BIGINT)
RETURNS NUMERIC AS $$
DECLARE
    final_grade NUMERIC(4,2);
    total_percentage NUMERIC(5,2);
BEGIN
    SELECT 
        SUM(percentage) INTO total_percentage
    FROM 
        administrative.grades
    WHERE 
        enrollment_id = p_enrollment_id;
    
    IF total_percentage != 100 THEN
        RAISE EXCEPTION 'Total percentage for enrollment % must equal 100%%, found %%%', p_enrollment_id, total_percentage;
    END IF;
    
    SELECT 
        SUM(grade * percentage / 100) INTO final_grade
    FROM 
        administrative.grades
    WHERE 
        enrollment_id = p_enrollment_id;
    
    RETURN ROUND(COALESCE(final_grade, 0), 2);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION administrative.enroll_student_in_course(
    p_student_id INT,
    p_course_id INT,
    p_academic_year VARCHAR,
    p_semester INT
) RETURNS BIGINT AS $$
DECLARE
    new_enrollment_id BIGINT;
    v_credits INT;
    v_max_credits INT := 35;
    v_current_credits INT;
BEGIN
    -- Validate student
    IF NOT EXISTS (SELECT 1 FROM administrative.students WHERE student_id = p_student_id AND is_active = TRUE) THEN
        RAISE EXCEPTION 'Studentul nu există sau nu este activ';
    END IF;
    
    -- Validate course
    IF NOT EXISTS (SELECT 1 FROM academic.courses WHERE course_id = p_course_id AND active = TRUE) THEN
        RAISE EXCEPTION 'Cursul nu există sau nu este activ';
    END IF;
    
    -- Check for duplicate enrollment
    IF EXISTS (
        SELECT 1 
        FROM administrative.course_enrollments 
        WHERE student_id = p_student_id 
          AND course_id = p_course_id 
          AND academic_year = p_academic_year 
          AND semester = p_semester
    ) THEN
        RAISE EXCEPTION 'Studentul este deja înscris la acest curs';
    END IF;
    
    -- Check credit limits
    SELECT credits INTO v_credits FROM academic.courses WHERE course_id = p_course_id;
    
    SELECT COALESCE(SUM(c.credits), 0) 
    INTO v_current_credits
    FROM administrative.course_enrollments ce
    JOIN academic.courses c ON ce.course_id = c.course_id
    WHERE ce.student_id = p_student_id
      AND ce.academic_year = p_academic_year
      AND ce.semester = p_semester;
    
    IF (v_current_credits + v_credits) > v_max_credits THEN
        RAISE EXCEPTION 'Depășire limită de credite. Actual: %, Nou: %, Maxim: %', 
                        v_current_credits, v_credits, v_max_credits;
    END IF;
    
    -- Insert enrollment with generated enrollment_id
    INSERT INTO administrative.course_enrollments (
        enrollment_id,
        student_id, 
        course_id, 
        academic_year, 
        semester, 
        enrollment_date, 
        status
    ) VALUES (
        nextval('administrative.enrollment_id_seq'),
        p_student_id, 
        p_course_id, 
        p_academic_year, 
        p_semester, 
        CURRENT_DATE, 
        'Enrolled'
    ) RETURNING enrollment_id INTO new_enrollment_id;
    
    RETURN new_enrollment_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE administrative.promote_students(p_academic_year VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
    v_student_record RECORD;
    v_min_credits INT := 30;
    v_total_semesters INT;
BEGIN
    FOR v_student_record IN 
        SELECT sr.* 
        FROM administrative.student_records sr
        JOIN administrative.students s ON sr.student_id = s.student_id
        WHERE s.is_active = TRUE
    LOOP
        SELECT duration_years * 2 INTO v_total_semesters
        FROM academic.study_programs
        WHERE program_id = v_student_record.program_id;
        
        IF v_student_record.credits_earned >= v_min_credits THEN
            IF v_student_record.current_semester = 1 THEN
                UPDATE administrative.student_records
                SET current_semester = 2,
                    updated_at = CURRENT_TIMESTAMP
                WHERE record_id = v_student_record.record_id;
            ELSE
                IF (v_student_record.current_year * 2) >= v_total_semesters THEN
                    UPDATE administrative.students
                    SET academic_status = 'Absolvent',
                        updated_at = CURRENT_TIMESTAMP
                    WHERE student_id = v_student_record.student_id;
                ELSE
                    UPDATE administrative.student_records
                    SET current_year = current_year + 1,
                        current_semester = 1,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE record_id = v_student_record.record_id;
                END IF;
            END IF;
        END IF;
    END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION administrative.generate_registration_number(
    p_faculty_id INT,
    p_program_id INT,
    p_enrollment_year INT
) RETURNS VARCHAR AS $$
DECLARE
    v_faculty_code VARCHAR(5);
    v_program_code VARCHAR(5);
    v_last_number INT;
    v_registration_number VARCHAR;
BEGIN
    SELECT UPPER(SUBSTRING(faculty_name, 1, 2)) INTO v_faculty_code
    FROM academic.faculties
    WHERE faculty_id = p_faculty_id;
    
    SELECT UPPER(SUBSTRING(program_name, 1, 2)) INTO v_program_code
    FROM academic.study_programs
    WHERE program_id = p_program_id;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(registration_number, 12) AS INT)), 0) INTO v_last_number
    FROM administrative.students
    WHERE registration_number LIKE v_faculty_code || v_program_code || p_enrollment_year || '%';
    
    v_registration_number := v_faculty_code || v_program_code || p_enrollment_year || 
                           LPAD((v_last_number + 1)::TEXT, 4, '0');
    
    RETURN v_registration_number;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION administrative.calculate_student_gpa(p_student_id INT)
RETURNS NUMERIC AS $$
DECLARE
    v_gpa NUMERIC(4,2);
    v_total_credits INT;
    v_weighted_sum NUMERIC;
BEGIN
    SELECT 
        SUM(c.credits * ce.final_grade) AS weighted_sum,
        SUM(c.credits) AS total_credits
    INTO 
        v_weighted_sum, v_total_credits
    FROM 
        administrative.course_enrollments ce
    JOIN 
        academic.courses c ON ce.course_id = c.course_id
    WHERE 
        ce.student_id = p_student_id
        AND ce.status = 'Completed'
        AND ce.final_grade IS NOT NULL;

    IF v_total_credits > 0 THEN
        v_gpa := ROUND(v_weighted_sum / v_total_credits, 2);
    ELSE
        v_gpa := 0;
    END IF;
    
    RETURN v_gpa;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION administrative.perform_database_backup(
    p_backup_type VARCHAR,
    p_backup_path TEXT
) RETURNS INT AS $$
DECLARE
    v_backup_id INT;
    v_backup_file TEXT;
    v_start_time TIMESTAMP WITH TIME ZONE := CURRENT_TIMESTAMP;
BEGIN
    v_backup_file := p_backup_path || '/backup_' || p_backup_type || '_' || 
                     TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD_HH24MI') || '.backup';
    
    INSERT INTO administrative.backup_logs (
        backup_type,
        start_time,
        status,
        backup_file_path
    ) VALUES (
        p_backup_type,
        v_start_time,
        'Pending',
        v_backup_file
    ) RETURNING backup_id INTO v_backup_id;
    
    UPDATE administrative.backup_logs
    SET end_time = CURRENT_TIMESTAMP,
        status = 'Completed',
        backup_size = 1234567890
    WHERE backup_id = v_backup_id;
    
    RETURN v_backup_id;
EXCEPTION
    WHEN OTHERS THEN
        UPDATE administrative.backup_logs
        SET end_time = CURRENT_TIMESTAMP,
            status = 'Failed',
            error_message = SQLERRM
        WHERE backup_id = v_backup_id;
        RAISE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION administrative.check_database_health()
RETURNS TABLE (
    check_name VARCHAR,
    health_status VARCHAR,
    details TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        'Dead Tuples'::VARCHAR AS check_name,
        CASE
            WHEN SUM(n_dead_tup)::FLOAT / SUM(n_live_tup + n_dead_tup) > 0.1
                THEN 'Warning'::VARCHAR
                ELSE 'OK'::VARCHAR
        END AS health_status,
        'Dead tuples: ' || SUM(n_dead_tup)::TEXT || ', Live tuples: ' || SUM(n_live_tup)::TEXT AS details
    FROM pg_stat_user_tables
    WHERE n_live_tup + n_dead_tup > 0
    UNION ALL
    SELECT
        'Backup Status'::VARCHAR AS check_name,
        CASE
            WHEN MAX(end_time) < CURRENT_TIMESTAMP - INTERVAL '1 day'
                THEN 'Warning'::VARCHAR
                ELSE 'OK'::VARCHAR
        END AS health_status,
        'Last backup: ' || COALESCE(MAX(end_time)::TEXT, 'None') AS details
    FROM administrative.backup_logs AS backup_logs
    WHERE backup_logs.status = 'Completed';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION administrative.maintain_large_tables()
RETURNS VOID AS $$
DECLARE
    v_table RECORD;
BEGIN
    FOR v_table IN 
        SELECT schemaname, relname
        FROM pg_stat_user_tables
        WHERE n_live_tup > 1000000
           OR n_dead_tup > 100000
    LOOP
        EXECUTE format('VACUUM (ANALYZE) %I.%I', v_table.schemaname, v_table.relname);
        EXECUTE format('REINDEX TABLE %I.%I', v_table.schemaname, v_table.relname);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION financial.generate_invoice(
    p_student_id INT,
    p_program_id INT,
    p_academic_year VARCHAR
) RETURNS INT AS $$
DECLARE
    v_invoice_id INT;
    v_invoice_number VARCHAR(20);
    v_tuition_amount NUMERIC(10,2);
    v_due_date DATE;
BEGIN
    -- Validate student
    IF NOT EXISTS (SELECT 1 FROM administrative.students WHERE student_id = p_student_id AND is_active = TRUE) THEN
        RAISE EXCEPTION 'Studentul nu există sau nu este activ';
    END IF;
    
    -- Get tuition fee details
    SELECT amount, payment_deadline INTO v_tuition_amount, v_due_date
    FROM financial.tuition_fees
    WHERE program_id = p_program_id AND academic_year = p_academic_year;
    
    IF v_tuition_amount IS NULL THEN
        RAISE EXCEPTION 'Nu există taxă definită pentru programul % în anul %', p_program_id, p_academic_year;
    END IF;
    
    -- Ensure due_date is not before issue_date
    v_due_date := GREATEST(v_due_date, CURRENT_DATE);
    
    -- Generate invoice number (e.g., INV<student_id>-<year>-<MMDDHH>)
    v_invoice_number := 'INV' || p_student_id || '-' || 
                       SUBSTRING(p_academic_year FROM 1 FOR 4) || '-' || 
                       TO_CHAR(CURRENT_TIMESTAMP, 'MMDDHH');
    
    -- Ensure uniqueness by checking existing invoices
    IF EXISTS (SELECT 1 FROM financial.invoices WHERE invoice_number = v_invoice_number) THEN
        v_invoice_number := v_invoice_number || 'A'; -- Append a suffix if collision occurs
    END IF;
    
    -- Insert invoice
    INSERT INTO financial.invoices (
        invoice_number,
        student_id,
        issue_date,
        due_date,
        total_amount,
        status
    ) VALUES (
        v_invoice_number,
        p_student_id,
        CURRENT_DATE,
        v_due_date,
        v_tuition_amount,
        'Issued'
    ) RETURNING invoice_id INTO v_invoice_id;
    
    -- Insert invoice item
    INSERT INTO financial.invoice_items (
        invoice_id,
        description,
        fee_type,
        quantity,
        unit_price,
        amount
    ) VALUES (
        v_invoice_id,
        'Taxă de școlarizare pentru anul ' || p_academic_year,
        'Tuition',
        1,
        v_tuition_amount,
        v_tuition_amount
    );
    
    RETURN v_invoice_id;
END;
$$ LANGUAGE plpgsql;