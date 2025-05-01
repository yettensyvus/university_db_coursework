-- main.sql
-- Entry point for University Student Management System database setup
-- Orchestrates the execution of sub-files to create schemas, tables, functions, etc.
-- Uses absolute paths for reliable execution in Docker container

\echo 'Starting database initialization...'

-- Create schemas
\i /docker-entrypoint-initdb.d/sql/create_schemas.sql

-- Enable extensions
\i /docker-entrypoint-initdb.d/sql/create_extensions.sql

-- Create tables
\i /docker-entrypoint-initdb.d/sql/create_tables.sql

-- Create indexes
\i /docker-entrypoint-initdb.d/sql/create_indexes.sql

-- Create views
\i /docker-entrypoint-initdb.d/sql/create_views.sql

-- Create functions and procedures
\i /docker-entrypoint-initdb.d/sql/create_functions.sql

-- Create triggers
\i /docker-entrypoint-initdb.d/sql/create_triggers.sql

-- Create roles and permissions
\i /docker-entrypoint-initdb.d/sql/create_roles.sql

-- Insert sample data
\i /docker-entrypoint-initdb.d/sql/insert_sample_data.sql

-- Invoke functions and triggers
\i /docker-entrypoint-initdb.d/sql/invoke_functions.sql

\echo 'Database setup completed successfully.'