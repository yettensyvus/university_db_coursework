-- First create roles
--CREATE ROLE admin WITH LOGIN PASSWORD 'admin_password';
CREATE ROLE professor WITH LOGIN PASSWORD 'professor_password';
CREATE ROLE student WITH LOGIN PASSWORD 'student_password';
CREATE ROLE financial_staff WITH LOGIN PASSWORD 'financial_password';
CREATE ROLE secretary WITH LOGIN PASSWORD 'secretary_password';
CREATE ROLE backup_operator WITH LOGIN PASSWORD 'backup_password';
CREATE ROLE auditor WITH LOGIN PASSWORD 'auditor_password';
CREATE ROLE sysadmin WITH LOGIN PASSWORD 'sysadmin_password';

-- Create the view with security barrier
CREATE OR REPLACE VIEW student_portal.my_academic_data 
WITH (security_barrier = true) AS
SELECT 
    s.student_id,
    s.registration_number,
    s.first_name,
    s.last_name,
    s.email,
    s.phone,
    s.address,
    s.enrollment_date,
    s.academic_status,
    sr.program_id,
    sp.program_name,
    sr.enrollment_year,
    sr.current_year,
    sr.current_semester,
    sr.study_form,
    sr.funding_form,
    sr.credits_earned,
    sr.gpa
FROM 
    administrative.students s
JOIN 
    administrative.student_records sr ON s.student_id = sr.student_id
JOIN 
    academic.study_programs sp ON sr.program_id = sp.program_id
WHERE 
    s.student_id = current_setting('app.current_student_id')::INT;

-- Grant permissions to the student role
GRANT SELECT ON student_portal.my_academic_data TO student;
GRANT USAGE ON SCHEMA student_portal TO student;

-- Grant other permissions (rest of your original grants)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academic TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA administrative TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA financial TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA academic TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA administrative TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA financial TO admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA academic TO admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA administrative TO admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA financial TO admin;

GRANT SELECT ON ALL TABLES IN SCHEMA academic TO professor;
GRANT SELECT ON administrative.students TO professor;
GRANT SELECT ON administrative.student_records TO professor;
GRANT SELECT ON administrative.study_groups TO professor;
GRANT SELECT ON administrative.student_groups TO professor;
GRANT SELECT, INSERT, UPDATE ON administrative.course_enrollments TO professor;
GRANT SELECT, INSERT, UPDATE ON administrative.grades TO professor;
GRANT SELECT, INSERT, UPDATE ON administrative.attendance TO professor;

GRANT SELECT ON academic.study_programs TO financial_staff;
GRANT SELECT ON administrative.students TO financial_staff;
GRANT SELECT ON administrative.student_records TO financial_staff;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA financial TO financial_staff;

GRANT SELECT ON ALL TABLES IN SCHEMA academic TO secretary;
GRANT SELECT, INSERT, UPDATE ON administrative.students TO secretary;
GRANT SELECT, INSERT, UPDATE ON administrative.student_records TO secretary;
GRANT SELECT, INSERT, UPDATE ON administrative.study_groups TO secretary;
GRANT SELECT, INSERT, UPDATE ON administrative.student_groups TO secretary;
GRANT SELECT, INSERT, UPDATE ON administrative.course_enrollments TO secretary;
GRANT SELECT, INSERT, UPDATE ON administrative.academic_documents TO secretary;
GRANT SELECT, INSERT ON administrative.dormitories TO secretary;
GRANT SELECT, INSERT, UPDATE ON administrative.dormitory_assignments TO secretary;

GRANT SELECT ON administrative.backup_logs TO backup_operator;
GRANT EXECUTE ON FUNCTION administrative.perform_database_backup TO backup_operator;
GRANT USAGE ON SCHEMA administrative TO backup_operator;

GRANT SELECT ON ALL TABLES IN SCHEMA academic TO auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA administrative TO auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA financial TO auditor;
GRANT SELECT ON administrative.backup_logs TO auditor;
GRANT SELECT ON administrative.audit_logs TO auditor;
GRANT USAGE ON SCHEMA academic, administrative, financial TO auditor;

GRANT SELECT, INSERT, UPDATE ON administrative.backup_logs TO sysadmin;
GRANT EXECUTE ON FUNCTION administrative.perform_database_backup TO sysadmin;
GRANT EXECUTE ON FUNCTION administrative.check_database_health TO sysadmin;
GRANT EXECUTE ON FUNCTION administrative.maintain_large_tables TO sysadmin;
GRANT pg_monitor, pg_signal_backend TO sysadmin;
GRANT USAGE ON SCHEMA administrative TO sysadmin;