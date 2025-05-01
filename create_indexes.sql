-- create_indexes.sql
-- Defines indexes for performance optimization

-- Academic schema
CREATE INDEX idx_faculty_name ON academic.faculties(faculty_name);
CREATE INDEX idx_department_faculty ON academic.departments(faculty_id);
CREATE INDEX idx_program_department ON academic.study_programs(department_id);
CREATE INDEX idx_course_department ON academic.courses(department_id);
CREATE INDEX idx_curriculum_program ON academic.curricula(program_id);
CREATE INDEX idx_curriculum_course_curriculum ON academic.curriculum_courses(curriculum_id);
CREATE INDEX idx_curriculum_course_course ON academic.curriculum_courses(course_id);

-- Administrative schema
CREATE INDEX idx_student_last_name ON administrative.students(last_name, first_name);
CREATE INDEX idx_student_email ON administrative.students(email);
CREATE INDEX idx_student_active ON administrative.students(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_student_record_student ON administrative.student_records(student_id);
CREATE INDEX idx_student_record_program ON administrative.student_records(program_id);
CREATE INDEX idx_study_group_program ON administrative.study_groups(program_id);
CREATE INDEX idx_student_group_student ON administrative.student_groups(student_id);
CREATE INDEX idx_student_group_group ON administrative.student_groups(group_id);
CREATE INDEX idx_course_enrollments_2023_2024_student ON administrative.course_enrollments_2023_2024(student_id);
CREATE INDEX idx_course_enrollments_2024_2025_student ON administrative.course_enrollments_2024_2025(student_id);
CREATE INDEX idx_course_enrollments_2025_2026_student ON administrative.course_enrollments_2025_2026(student_id);
CREATE INDEX idx_grade_enrollment ON administrative.grades(enrollment_id);
CREATE INDEX idx_attendance_student ON administrative.attendance(student_id);
CREATE INDEX idx_attendance_course ON administrative.attendance(course_id);
CREATE INDEX idx_academic_document_student ON administrative.academic_documents(student_id);
CREATE INDEX idx_scholarship_student ON administrative.scholarships(student_id);
CREATE INDEX idx_mobility_student ON administrative.mobility_programs(student_id);
CREATE INDEX idx_dormitory_assignment_student ON administrative.dormitory_assignments(student_id);
CREATE INDEX idx_dormitory_assignment_dormitory ON administrative.dormitory_assignments(dormitory_id);

-- Financial schema
CREATE INDEX idx_tuition_fee_program ON financial.tuition_fees(program_id);
CREATE INDEX idx_invoice_student ON financial.invoices(student_id);
CREATE INDEX idx_invoice_status ON financial.invoices(status);
CREATE INDEX idx_invoice_item_invoice ON financial.invoice_items(invoice_id);
CREATE INDEX idx_payment_invoice ON financial.payments(invoice_id);
CREATE INDEX idx_payment_student ON financial.payments(student_id);
CREATE INDEX idx_payment_plan_student ON financial.payment_plans(student_id);
CREATE INDEX idx_payment_plan_invoice ON financial.payment_plans(invoice_id);
CREATE INDEX idx_installment_plan ON financial.installments(plan_id);
CREATE INDEX idx_refund_student ON financial.refunds(student_id);

-- Audit and backup
CREATE INDEX idx_audit_table_name ON administrative.audit_logs(table_name);
CREATE INDEX idx_backup_status ON administrative.backup_logs(status);
