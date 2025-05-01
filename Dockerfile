# Use the official PostgreSQL 16 image as the base
FROM postgres:16

# Install build dependencies and required libraries
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    postgresql-server-dev-16 \
    && rm -rf /var/lib/apt/lists/*

# Install pg_cron
RUN git clone https://github.com/citusdata/pg_cron.git /tmp/pg_cron \
    && cd /tmp/pg_cron \
    && make && make install \
    && cd /tmp \
    && rm -rf pg_cron

# Install pgstattuple and tablefunc
RUN apt-get update && apt-get install -y \
    postgresql-contrib-16 \
    && rm -rf /var/lib/apt/lists/*

# Configure PostgreSQL to load pg_cron
RUN echo "shared_preload_libraries = 'pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "cron.database_name = 'university_db'" >> /usr/share/postgresql/postgresql.conf.sample

# Expose the default PostgreSQL port
EXPOSE 5432