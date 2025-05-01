-- invoke_functions.sql

-- Schedule recurring maintenance jobs using pg_cron
SELECT cron.schedule(
    'daily_full_backup',
    '0 2 * * *', -- Every day at 2:00 AM
    $$SELECT administrative.perform_database_backup('Full', '/var/backups/university_db')$$
);

SELECT cron.schedule(
    'daily_vacuum_analyze',
    '0 3 * * *', -- Every day at 3:00 AM
    $$VACUUM (ANALYZE, VERBOSE)$$
);

SELECT cron.schedule(
    'monthly_reindex',
    '0 4 1 * *', -- First day of the month at 4:00 AM
    $$REINDEX DATABASE university_db$$
);

SELECT cron.schedule(
    'weekly_table_maintenance',
    '0 5 * * 0', -- Every Sunday at 5:00 AM
    $$SELECT administrative.maintain_large_tables()$$
);