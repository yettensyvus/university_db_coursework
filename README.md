# University Student Management System Database Documentation

## Introduction

This documentation provides a comprehensive guide for setting up, using, and maintaining a PostgreSQL database for the University Student Management System. The system manages academic, administrative, and financial operations for a university, including student records, course enrollments, grades, and tuition fees. It is deployed using Docker Compose for portability and ease of setup on Windows environments, with a modular SQL file structure for improved maintainability.

## Overview

### Purpose

The University Student Management System Database is a PostgreSQL-based solution designed to manage university operations, including student records, course enrollments, grades, tuition fees, and more. It provides a robust, scalable platform for academic, administrative, and financial tasks, deployed using Docker for consistency across environments.

### Key Features

- **Modular Schemas**: Organized into `academic`, `administrative`, `financial`, and `student_portal` for clear separation of concerns.
- **PostgreSQL Extensions**:
  - `pg_cron`: Automates scheduled tasks like backups.
  - `pgstattuple`: Monitors table bloat and performance.
  - `tablefunc`: Enables advanced SQL queries.
- **Automation**:
  - Stored procedures for enrollment, GPA calculation, and invoice generation.
  - Triggers for maintaining data consistency (e.g., updating grades, timestamps).
  - Views for reporting (e.g., student academic status, financial status).
- **Dockerized Deployment**: Runs in a container with persistent storage and automatic schema initialization via a modular SQL structure.
- **Windows Compatibility**: Tailored for Windows with Docker Desktop, addressing file path and line ending issues.

### Components

- **Database Schema**: Defined in a modular SQL structure:
  - `main.sql`: Orchestrates the execution of sub-files.
  - Sub-files: `create_extensions.sql`, `create_schemas.sql`, `create_tables.sql`, `create_indexes.sql`, `create_views.sql`, `create_functions.sql`, `create_triggers.sql`, `create_roles.sql`.
- **Docker Configuration**:
  - `docker-compose.yml`: Defines the PostgreSQL service and volumes.
  - `Dockerfile`: Customizes the PostgreSQL image with extensions.
  - `init-db.sh`: Initializes the database by executing `main.sql`.

## System Requirements

### Hardware
- **Operating System**: Windows 10/11 (Professional or Enterprise recommended for Hyper-V support).
- **Memory**: 4GB RAM allocated to Docker (8GB recommended).
- **Storage**: 10GB free disk space for database and Docker images.
- **Processor**: Multi-core processor (e.g., Intel i5 or equivalent).

### Software
- **Docker Desktop**: Latest version with WSL2 backend enabled.
- **Command Line Interface**: Git Bash (recommended), PowerShell, or Command Prompt.
- **Text Editor**: VS Code, Notepad++, or similar for ensuring Unix line endings (`LF`).
- **PostgreSQL Client**: `psql`, pgAdmin, or DBeaver for database access.

### Prerequisites
- **Windows Subsystem for Linux (WSL2)**: Recommended for better Docker performance.
- **Hyper-V**: Enabled for Docker Desktop if WSL2 is not used.
- **Internet Connection**: Required for downloading Docker images and dependencies.

## Installation and Setup

### Step 1: Install Docker Desktop
1. Download and install **Docker Desktop** from [Docker's official site](https://www.docker.com/products/docker-desktop/).
2. Enable **WSL2** for better performance:
   - Open Docker Desktop > Settings > General > Check "Use WSL 2 based engine".
   - Settings > Resources > WSL Integration > Enable integration with your WSL distribution (e.g., Ubuntu).
3. Ensure Hyper-V or WSL2 is enabled:
   - Control Panel > Programs > Turn Windows features on or off > Enable "Hyper-V" and "Windows Subsystem for Linux".

### Step 2: Prepare the Project Directory
1. Create a directory, e.g., `C:\university_db_docker`.
2. Organize the project with the following structure:
   ```
   C:\university_db_docker\
     ├── docker-compose.yml
     ├── Dockerfile
     ├── init-db.sh
     ├── sql\
     │   ├── main.sql
     │   ├── create_extensions.sql
     │   ├── create_schemas.sql
     │   ├── create_tables.sql
     │   ├── create_indexes.sql
     │   ├── create_views.sql
     │   ├── create_functions.sql
     │   ├── create_triggers.sql
     │   ├── create_roles.sql
   ```
3. Ensure `init-db.sh` and all `.sql` files have Unix line endings (`LF`):
   - In **VS Code**: Open each file, set "End of Line Sequence" to `LF` (bottom-right corner), and save.
   - In **Notepad++**: Edit > EOL Conversion > Unix (LF), then save.
   - Using Git Bash (if installed):
     ```bash
     cd C:\university_db_docker
     dos2unix init-db.sh
     dos2unix sql/*.sql
     ```

### Step 3: Start the Database
1. Open **Git Bash**, **PowerShell**, or **Command Prompt** in the project directory:
   ```bash
   cd C:\university_db_docker
   ```
2. Run Docker Compose to start the PostgreSQL container:
   ```bash
   docker-compose up -d
   ```
3. Docker will:
   - Build a custom PostgreSQL 16 image with `pg_cron`, `pgstattuple`, and `tablefunc`.
   - Create a persistent volume (`university_postgres_data`).
   - Initialize the database by executing `main.sql`, which includes all sub-files.
   - Expose port `5432` for connections.

### Step 4: Verify the Setup
1. Check container status:
   ```bash
   docker ps
   ```
   Ensure the `university_db` container is running.
2. View logs to confirm initialization:
   ```bash
   docker logs university_db
   ```
   Look for "Database initialization completed successfully."
3. Connect to the database using a PostgreSQL client:
   ```bash
   psql -h localhost -p 5432 -U admin -d university_db
   ```
   - **Password**: `admin_password`
   - Verify tables and data:
     ```sql
     \dt academic.*
     \dt administrative.*
     \dt financial.*
     SELECT * FROM academic.faculties;
     ```

## Database Structure

### Overview

The database is organized into four schemas: `academic`, `administrative`, `financial`, and `student_portal`. The schema is defined across multiple SQL files for modularity, executed via `main.sql`.

### SQL File Structure
- **main.sql**: Orchestrates the execution of sub-files.
- **create_extensions.sql**: Enables `pg_cron`, `pgstattuple`, and `tablefunc`.
- **create_schemas.sql**: Defines the four schemas.
- **create_tables.sql**: Creates all tables.
- **create_indexes.sql**: Defines indexes for performance.
- **create_views.sql**: Creates views and materialized views.
- **create_functions.sql**: Defines stored procedures and functions.
- **create_triggers.sql**: Defines triggers for automation.
- **create_roles.sql**: Sets up roles and permissions.

### Schemas and Tables

#### Academic Schema
- **Tables**:
  - `faculties`: Faculty information.
  - `departments`: Department details under faculties.
  - `study_programs`: Academic programs (e.g., Bachelor's, Master's).
  - `courses`: Course catalog with credits and status.
  - `curricula`: Program curricula for specific academic years.
  - `curriculum_courses`: Maps courses to curricula.
- **Purpose**: Manages academic structure and course offerings.

#### Administrative Schema
- **Tables**:
  - `students`: Student personal and enrollment data.
  - `student_records`: Academic progress (e.g., credits, GPA).
  - `study_groups` and `student_groups`: Group assignments.
  - `course_enrollments_partitioned`: Student course registrations (partitioned by year).
  - `grades`: Individual grades for evaluations.
  - `attendance`: Tracks student attendance.
  - `academic_documents`: Certificates and transcripts.
  - `scholarships`: Financial aid records.
  - `mobility_programs`: Exchange program details.
  - `dormitories` and `dormitory_assignments`: Housing management.
  - `backup_logs` and `audit_logs`: System maintenance and auditing.
- **Purpose**: Handles student administration and operational data.

#### Financial Schema
- **Tables**:
  - `tuition_fees`: Program-specific fee structures.
  - `invoices` and `invoice_items`: Billing records.
  - `payments`: Payment transactions.
  - `payment_plans` and `installments`: Payment schedules.
  - `refunds`: Refund requests and statuses.
- **Purpose**: Manages financial transactions and billing.

#### Student Portal Schema
- **Views**:
  - `my_academic_data`: Student-accessible academic information with row-level security.
- **Purpose**: Provides a secure interface for students to view their data.

### Key Features
- **Extensions**:
  - `pg_cron`: Schedules backup and maintenance tasks.
  - `pgstattuple`: Monitors table bloat and dead tuples.
  - `tablefunc`: Supports advanced SQL functions.
- **Functions and Procedures**:
  - `enroll_student_in_course`: Registers students in courses.
  - `calculate_final_grade`: Computes weighted grades.
  - `calculate_student_gpa`: Updates student GPA.
  - `generate_invoice`: Creates tuition invoices.
  - `perform_database_backup`: Manages backups.
  - `promote_students`: Advances students to the next year/semester.
- **Triggers**:
  - Updates `updated_at` timestamps.
  - Maintains `final_grade` and `credits_earned` consistency.
  - Logs changes to `audit_logs` for tracking.
- **Views**:
  - `student_academic_status`: Summarizes student progress.
  - `student_financial_status`: Tracks payment status.
  - `dormitory_occupancy`: Monitors housing capacity.
  - `course_enrollment_statistics`: Analyzes course performance.
  - `digital_gradebook`: Materialized view for grade reports.

## Usage

### Accessing the Database
- **Command Line**:
  ```bash
  psql -h localhost -p 5432 -U admin -d university_db
  ```
  Password: `admin_password`
- **GUI Tools**:
  - **pgAdmin**:
    - Host: `localhost`
    - Port: `5432`
    - Username: `admin`
    - Password: `admin_password`
    - Database: `university_db`
  - **DBeaver**: Use the same connection details.