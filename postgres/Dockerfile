# Use the official PostgreSQL image as a base
FROM postgres:latest

# Copy the initialization SQL file and properties file to the Docker image
COPY init.sql /docker-entrypoint-initdb.d/
COPY ../config.properties /config.properties

# Use environment file for configurations
ENV POSTGRES_DB=the_melvin_bank_db
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=adminpassword