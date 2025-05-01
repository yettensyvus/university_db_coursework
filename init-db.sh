#!/bin/bash
set -ex

echo "Starting database initialization..."
echo "Contents of init directory:"
ls -la /docker-entrypoint-initdb.d/

echo "Waiting for PostgreSQL to be ready..."
until psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q'; do
  >&2 echo "PostgreSQL is not ready yet, waiting..."
  sleep 2
done

echo "Executing main SQL script..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/sql/main.sql

echo "Database initialization completed successfully."