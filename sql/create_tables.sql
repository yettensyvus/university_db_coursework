-- create_tables.sql
-- Creates all tables for the University Student Management System

-- Academic Schema
CREATE TABLE academic.faculties (
    faculty_id SERIAL PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL CHECK (faculty_name <> ''),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic.departments (
    department_id SERIAL PRIMARY KEY,
    faculty_id INT REFERENCES academic.faculties(faculty_id) ON DELETE RESTRICT,
    department_name VARCHAR(100) NOT NULL CHECK (department_name <> ''),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic.study_programs (
    program_id SERIAL PRIMARY KEY,
    department_id INT REFERENCES academic.departments(department_id) ON DELETE RESTRICT,
    program_name VARCHAR(100) NOT NULL CHECK (program_name <> ''),
    degree_level VARCHAR(50) NOT NULL CHECK (degree_level IN ('Licență', 'Master', 'Doctorat')),
    duration_years INT NOT NULL CHECK (duration_years > 0),
    credits_required INT NOT NULL CHECK (credits_required > 0),
    language VARCHAR(50) DEFAULT 'Română' CHECK (language <> ''),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic.courses (
    course_id SERIAL PRIMARY KEY,
    department_id INT REFERENCES academic.departments(department_id) ON DELETE RESTRICT,
    course_code VARCHAR(20) NOT NULL UNIQUE CHECK (course_code <> ''),
    course_name VARCHAR(100) NOT NULL CHECK (course_name <> ''),
    credits INT NOT NULL CHECK (credits > 0),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic.curricula (
    curriculum_id SERIAL PRIMARY KEY,
    program_id INT REFERENCES academic.study_programs(program_id) ON DELETE RESTRICT,
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year ~ '^[0-9]{4}-[0-9]{4}$'),
    status VARCHAR(20) DEFAULT 'Draft' CHECK (status IN ('Draft', 'Active', 'Archived')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(program_id, academic_year)
);

CREATE TABLE academic.curriculum_courses (
    curriculum_course_id SERIAL PRIMARY KEY,
    curriculum_id INT REFERENCES academic.curricula(curriculum_id) ON DELETE CASCADE,
    course_id INT REFERENCES academic.courses(course_id) ON DELETE RESTRICT,
    semester INT NOT NULL CHECK (semester IN (1, 2)),
    year_of_study INT NOT NULL CHECK (year_of_study > 0),
    is_mandatory BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(curriculum_id, course_id, semester, year_of_study)
);

-- Administrative Schema
CREATE TABLE administrative.students (
    student_id SERIAL PRIMARY KEY,
    registration_number VARCHAR(20) UNIQUE NOT NULL CHECK (registration_number <> ''),
    first_name VARCHAR(50) NOT NULL CHECK (first_name <> ''),
    last_name VARCHAR(50) NOT NULL CHECK (last_name <> ''),
    birth_date DATE NOT NULL CHECK (birth_date < CURRENT_DATE),
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    phone VARCHAR(20) CHECK (phone ~ '^\+?[0-9]{10,15}$'),
    address TEXT,
    enrollment_date DATE NOT NULL CHECK (enrollment_date <= CURRENT_DATE),
    is_active BOOLEAN DEFAULT TRUE,
    academic_status VARCHAR(20) DEFAULT 'Active' CHECK (academic_status IN ('Active', 'Suspendat', 'Exmatriculat', 'Absolvent')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE administrative.student_records (
    record_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    program_id INT REFERENCES academic.study_programs(program_id) ON DELETE RESTRICT,
    enrollment_year INT NOT NULL CHECK (enrollment_year >= 2000 AND enrollment_year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    current_year INT NOT NULL CHECK (current_year > 0),
    current_semester INT NOT NULL CHECK (current_semester IN (1, 2)),
    study_form VARCHAR(50) NOT NULL CHECK (study_form IN ('IF', 'ID', 'IFR')),
    funding_form VARCHAR(50) NOT NULL CHECK (funding_form IN ('Buget', 'Taxă')),
    credits_earned INT DEFAULT 0 CHECK (credits_earned >= 0),
    gpa NUMERIC(4,2) CHECK (gpa >= 0 AND gpa <= 10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, program_id, enrollment_year)
);

CREATE TABLE administrative.study_groups (
    group_id SERIAL PRIMARY KEY,
    group_code VARCHAR(20) NOT NULL CHECK (group_code <> ''),
    program_id INT REFERENCES academic.study_programs(program_id) ON DELETE RESTRICT,
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year ~ '^[0-9]{4}-[0-9]{4}$'),
    year_of_study INT NOT NULL CHECK (year_of_study > 0),
    semester INT NOT NULL CHECK (semester IN (1, 2)),
    max_students INT CHECK (max_students > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(group_code, academic_year)
);

CREATE TABLE administrative.student_groups (
    student_group_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    group_id INT REFERENCES administrative.study_groups(group_id) ON DELETE CASCADE,
    start_date DATE NOT NULL CHECK (start_date <= CURRENT_DATE),
    is_group_leader BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, group_id)
);

CREATE TABLE administrative.course_enrollments_partitioned (
    enrollment_id BIGINT NOT NULL,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year ~ '^[0-9]{4}-[0-9]{4}$'),
    semester INT NOT NULL CHECK (semester IN (1, 2)),
    enrollment_date DATE DEFAULT CURRENT_DATE CHECK (enrollment_date <= CURRENT_DATE),
    status VARCHAR(20) DEFAULT 'Enrolled' CHECK (status IN ('Enrolled', 'Withdrawn', 'Completed', 'Failed', 'Overdue')),
    final_grade NUMERIC(4,2) CHECK (final_grade >= 1 AND final_grade <= 10 OR final_grade IS NULL),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (enrollment_id, academic_year)
) PARTITION BY LIST (academic_year);

-- Add foreign key constraints after table creation for partitioning
ALTER TABLE administrative.course_enrollments_partitioned 
    ADD CONSTRAINT fk_student_id FOREIGN KEY (student_id) REFERENCES administrative.students(student_id) ON DELETE CASCADE;
ALTER TABLE administrative.course_enrollments_partitioned 
    ADD CONSTRAINT fk_course_id FOREIGN KEY (course_id) REFERENCES academic.courses(course_id) ON DELETE RESTRICT;
ALTER TABLE administrative.course_enrollments_partitioned 
    ADD CONSTRAINT unique_enrollment UNIQUE(student_id, course_id, academic_year, semester);

-- Create partition sequence
CREATE SEQUENCE administrative.enrollment_id_seq START 1;

-- Create partitions
CREATE TABLE administrative.course_enrollments_2023_2024
    PARTITION OF administrative.course_enrollments_partitioned
    FOR VALUES IN ('2023-2024');

CREATE TABLE administrative.course_enrollments_2024_2025
    PARTITION OF administrative.course_enrollments_partitioned
    FOR VALUES IN ('2024-2025');

CREATE TABLE administrative.course_enrollments_2025_2026
    PARTITION OF administrative.course_enrollments_partitioned
    FOR VALUES IN ('2025-2026');

CREATE TABLE administrative.grades (
    grade_id SERIAL PRIMARY KEY,
    enrollment_id BIGINT NOT NULL,
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year ~ '^[0-9]{4}-[0-9]{4}$'),
    evaluation_type VARCHAR(50) NOT NULL CHECK (evaluation_type IN ('Exam', 'Midterm', 'Project', 'Lab', 'Quiz')),
    evaluation_date DATE NOT NULL CHECK (evaluation_date <= CURRENT_DATE),
    grade NUMERIC(4,2) NOT NULL CHECK (grade >= 1 AND grade <= 10),
    percentage NUMERIC(5,2) NOT NULL CHECK (percentage > 0 AND percentage <= 100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id, academic_year) REFERENCES administrative.course_enrollments_partitioned(enrollment_id, academic_year) ON DELETE CASCADE
);

CREATE TABLE administrative.attendance (
    attendance_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    course_id INT REFERENCES academic.courses(course_id) ON DELETE RESTRICT,
    date DATE NOT NULL CHECK (date <= CURRENT_DATE),
    status VARCHAR(20) NOT NULL CHECK (status IN ('Present', 'Absent', 'Late', 'Excused')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, course_id, date)
);

CREATE TABLE administrative.academic_documents (
    document_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL CHECK (document_type IN ('Diplomă', 'Adeverință', 'Situație școlară')),
    issue_date DATE NOT NULL CHECK (issue_date <= CURRENT_DATE),
    document_number VARCHAR(50) UNIQUE CHECK (document_number <> ''),
    status VARCHAR(20) DEFAULT 'Valid' CHECK (status IN ('Valid', 'Expired', 'Revoked')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE administrative.scholarships (
    scholarship_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    scholarship_type VARCHAR(50) NOT NULL CHECK (scholarship_type IN ('Merit', 'Social', 'Performanță', 'Erasmus')),
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year ~ '^[0-9]{4}-[0-9]{4}$'),
    semester INT NOT NULL CHECK (semester IN (1, 2)),
    amount NUMERIC(8,2) NOT NULL CHECK (amount > 0),
    start_date DATE NOT NULL CHECK (start_date <= CURRENT_DATE),
    end_date DATE NOT NULL CHECK (end_date >= start_date),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE administrative.mobility_programs (
    mobility_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    program_type VARCHAR(50) NOT NULL CHECK (program_type IN ('Erasmus', 'Bilateral', 'Research')),
    partner_institution VARCHAR(100) NOT NULL CHECK (partner_institution <> ''),
    country VARCHAR(100) NOT NULL CHECK (country <> ''),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date >= start_date),
    status VARCHAR(20) DEFAULT 'Planned' CHECK (status IN ('Planned', 'Ongoing', 'Completed', 'Cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE administrative.dormitories (
    dormitory_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL CHECK (name <> ''),
    address TEXT NOT NULL CHECK (address <> ''),
    total_rooms INT NOT NULL CHECK (total_rooms > 0),
    total_capacity INT NOT NULL CHECK (total_capacity > 0),
    monthly_fee NUMERIC(8,2) CHECK (monthly_fee >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE administrative.dormitory_assignments (
    assignment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    dormitory_id INT REFERENCES administrative.dormitories(dormitory_id) ON DELETE RESTRICT,
    room_number VARCHAR(10) NOT NULL CHECK (room_number <> ''),
    bed_number INT NOT NULL CHECK (bed_number > 0),
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year ~ '^[0-9]{4}-[0-9]{4}$'),
    start_date DATE NOT NULL,
    end_date DATE CHECK (end_date >= start_date OR end_date IS NULL),
    monthly_fee NUMERIC(8,2) NOT NULL CHECK (monthly_fee >= 0),
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Terminated', 'Suspended')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(dormitory_id, room_number, bed_number, academic_year)
);

-- Financial Schema
CREATE TABLE financial.tuition_fees (
    fee_id SERIAL PRIMARY KEY,
    program_id INT REFERENCES academic.study_programs(program_id) ON DELETE RESTRICT,
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year ~ '^[0-9]{4}-[0-9]{4}$'),
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    payment_deadline DATE, -- Removed CHECK constraint as it can cause issues when inserting historical data
    installments_allowed BOOLEAN DEFAULT TRUE,
    max_installments INT CHECK (max_installments > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(program_id, academic_year)
);

CREATE TABLE financial.invoices (
    invoice_id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(20) UNIQUE NOT NULL CHECK (invoice_number <> ''),
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    issue_date DATE NOT NULL CHECK (issue_date <= CURRENT_DATE),
    due_date DATE NOT NULL CHECK (due_date >= issue_date),
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount > 0),
    status VARCHAR(20) DEFAULT 'Issued' CHECK (status IN ('Issued', 'Paid', 'Overdue', 'Cancelled', 'Partially Paid')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE financial.invoice_items (
    item_id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES financial.invoices(invoice_id) ON DELETE CASCADE,
    description VARCHAR(255) NOT NULL CHECK (description <> ''),
    fee_type VARCHAR(50) NOT NULL CHECK (fee_type IN ('Tuition', 'Misc', 'Penalty', 'Accommodation')),
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    unit_price NUMERIC(8,2) NOT NULL CHECK (unit_price >= 0),
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE financial.payments (
    payment_id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES financial.invoices(invoice_id) ON DELETE CASCADE,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    payment_date DATE NOT NULL CHECK (payment_date <= CURRENT_DATE),
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('Cash', 'Card', 'Transfer', 'Online')),
    status VARCHAR(20) DEFAULT 'Completed' CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE financial.payment_plans (
    plan_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    invoice_id INT REFERENCES financial.invoices(invoice_id) ON DELETE CASCADE,
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount > 0),
    number_of_installments INT NOT NULL CHECK (number_of_installments > 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date >= start_date),
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Completed', 'Defaulted', 'Cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE financial.installments (
    installment_id SERIAL PRIMARY KEY,
    plan_id INT REFERENCES financial.payment_plans(plan_id) ON DELETE CASCADE,
    installment_number INT NOT NULL CHECK (installment_number > 0),
    due_date DATE NOT NULL, -- Removed CHECK constraint for historical data compatibility
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Paid', 'Overdue', 'Cancelled')),
    payment_id INT REFERENCES financial.payments(payment_id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(plan_id, installment_number)
);

CREATE TABLE financial.refunds (
    refund_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES administrative.students(student_id) ON DELETE CASCADE,
    payment_id INT REFERENCES financial.payments(payment_id) ON DELETE CASCADE,
    request_date DATE NOT NULL CHECK (request_date <= CURRENT_DATE),
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    reason TEXT NOT NULL CHECK (reason <> ''),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Processed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Backup and Audit Tables
CREATE TABLE administrative.backup_logs (
    backup_id SERIAL PRIMARY KEY,
    backup_type VARCHAR(20) NOT NULL CHECK (backup_type IN ('Full', 'Incremental')),
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Pending', 'Completed', 'Failed')),
    backup_file_path TEXT NOT NULL CHECK (backup_file_path <> ''),
    backup_size BIGINT CHECK (backup_size >= 0),
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE administrative.audit_logs (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL CHECK (table_name <> ''),
    operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    user_name TEXT NOT NULL,
    change_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB,
    new_data JSONB,
    changed_by_role VARCHAR(50),
    changed_by_user_id INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
