-- create_views.sql
-- Defines views and materialized views

CREATE VIEW administrative.course_enrollments AS
    SELECT * FROM administrative.course_enrollments_partitioned;

CREATE OR REPLACE VIEW academic.student_academic_status AS
SELECT 
    s.student_id,
    s.registration_number,
    s.first_name,
    s.last_name,
    sr.program_id,
    sp.program_name,
    sr.enrollment_year,
    sr.current_year,
    sr.current_semester,
    sr.study_form,
    sr.funding_form,
    sr.credits_earned,
    sr.gpa,
    COUNT(ce.enrollment_id) AS enrolled_courses,
    COUNT(CASE WHEN ce.status = 'Completed' THEN 1 END) AS completed_courses
FROM 
    administrative.students s
JOIN 
    administrative.student_records sr ON s.student_id = sr.student_id
JOIN 
    academic.study_programs sp ON sr.program_id = sp.program_id
LEFT JOIN 
    administrative.course_enrollments ce ON s.student_id = ce.student_id
WHERE 
    s.is_active = TRUE
GROUP BY 
    s.student_id, s.registration_number, s.first_name, s.last_name,
    sr.program_id, sp.program_name, sr.enrollment_year, sr.current_year,
    sr.current_semester, sr.study_form, sr.funding_form, sr.credits_earned, sr.gpa;

CREATE OR REPLACE VIEW financial.student_financial_status AS
SELECT 
    s.student_id,
    s.registration_number,
    s.first_name,
    s.last_name,
    sp.program_name,
    SUM(CASE WHEN i.status = 'Paid' THEN i.total_amount ELSE 0 END) AS total_paid,
    SUM(CASE WHEN i.status IN ('Issued', 'Overdue', 'Partially Paid') THEN i.total_amount ELSE 0 END) AS total_due,
    COUNT(CASE WHEN i.status = 'Overdue' THEN 1 END) AS overdue_invoices,
    pp.plan_id IS NOT NULL AS has_payment_plan,
    CASE 
        WHEN pp.status = 'Active' THEN 'În rate'
        WHEN SUM(CASE WHEN i.status IN ('Issued', 'Overdue', 'Partially Paid') THEN i.total_amount ELSE 0 END) > 0 THEN 'Restanță'
        ELSE 'La zi'
    END AS financial_status
FROM 
    administrative.students s
JOIN 
    administrative.student_records sr ON s.student_id = sr.student_id
JOIN 
    academic.study_programs sp ON sr.program_id = sp.program_id
LEFT JOIN 
    financial.invoices i ON s.student_id = i.student_id
LEFT JOIN 
    financial.payment_plans pp ON s.student_id = pp.student_id AND pp.status = 'Active'
GROUP BY 
    s.student_id, s.registration_number, s.first_name, s.last_name, sp.program_name, pp.plan_id, pp.status;

CREATE OR REPLACE VIEW administrative.dormitory_occupancy AS
SELECT 
    d.dormitory_id,
    d.name AS dormitory_name,
    d.total_capacity,
    COUNT(da.assignment_id) AS current_occupancy,
    d.total_capacity - COUNT(da.assignment_id) AS available_spots,
    ROUND((COUNT(da.assignment_id)::NUMERIC / d.total_capacity) * 100, 2) AS occupancy_percentage,
    SUM(da.monthly_fee) AS monthly_revenue
FROM 
    administrative.dormitories d
LEFT JOIN 
    administrative.dormitory_assignments da ON d.dormitory_id = da.dormitory_id AND da.status = 'Active'
GROUP BY 
    d.dormitory_id, d.name, d.total_capacity;

CREATE OR REPLACE VIEW academic.course_enrollment_statistics AS
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    d.department_name,
    COUNT(ce.enrollment_id) AS total_enrollments,
    ROUND(AVG(ce.final_grade), 2) AS average_grade,
    COUNT(CASE WHEN ce.status = 'Completed' AND ce.final_grade >= 5 THEN 1 END) AS passed_students,
    COUNT(CASE WHEN ce.status = 'Completed' AND ce.final_grade < 5 THEN 1 END) AS failed_students,
    CASE WHEN COUNT(ce.enrollment_id) > 0 
         THEN ROUND((COUNT(CASE WHEN ce.status = 'Completed' AND ce.final_grade >= 5 THEN 1 END)::NUMERIC / 
                    COUNT(ce.enrollment_id)) * 100, 2)
         ELSE 0
    END AS pass_rate
FROM 
    academic.courses c
JOIN 
    academic.departments d ON c.department_id = d.department_id
LEFT JOIN 
    administrative.course_enrollments ce ON c.course_id = ce.course_id
GROUP BY 
    c.course_id, c.course_code, c.course_name, d.department_name;

CREATE MATERIALIZED VIEW administrative.digital_gradebook AS
SELECT 
    s.registration_number,
    s.first_name,
    s.last_name,
    sp.program_name,
    sr.current_year,
    sr.current_semester,
    sg.group_code,
    c.course_code,
    c.course_name,
    ce.academic_year,
    ce.semester,
    ce.final_grade,
    ce.status,
    ARRAY_AGG(DISTINCT g.grade || ' (' || g.evaluation_type || ', ' || 
              TO_CHAR(g.evaluation_date, 'DD.MM.YYYY') || ')') AS detailed_grades
FROM 
    administrative.students s
JOIN 
    administrative.student_records sr ON s.student_id = sr.student_id
JOIN 
    academic.study_programs sp ON sr.program_id = sp.program_id
LEFT JOIN 
    administrative.student_groups sg_relation ON s.student_id = sg_relation.student_id
LEFT JOIN 
    administrative.study_groups sg ON sg_relation.group_id = sg.group_id
JOIN 
    administrative.course_enrollments ce ON s.student_id = ce.student_id
JOIN 
    academic.courses c ON ce.course_id = c.course_id
LEFT JOIN 
    administrative.grades g ON ce.enrollment_id = g.enrollment_id AND ce.academic_year = g.academic_year
WHERE 
    s.is_active = TRUE
GROUP BY 
    s.registration_number, s.first_name, s.last_name, sp.program_name,
    sr.current_year, sr.current_semester, sg.group_code, c.course_code,
    c.course_name, ce.academic_year, ce.semester, ce.final_grade, ce.status;

CREATE INDEX idx_digital_gradebook_student ON administrative.digital_gradebook(registration_number);
CREATE INDEX idx_digital_gradebook_course ON administrative.digital_gradebook(course_code);

-- Create pgstattuple extension if not exists
CREATE EXTENSION IF NOT EXISTS pgstattuple;

CREATE OR REPLACE VIEW administrative.table_stats AS
SELECT 
    schemaname,
    relname AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    pg_total_relation_size(relid) AS total_size,
    stats.table_len AS table_size,
    stats.dead_tuple_len AS dead_tuple_size,
    stats.free_space AS free_space
FROM 
    pg_stat_user_tables
CROSS JOIN LATERAL
    pgstattuple(relid) AS stats;