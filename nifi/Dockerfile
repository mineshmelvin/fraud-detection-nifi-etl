# Dockerfile for Nifi
FROM apache/nifi:latest

# Install PostgreSQL JDBC Driver
RUN curl -L -o /opt/nifi/nifi-current/lib/postgresql-jdbc.jar https://jdbc.postgresql.org/download/postgresql-42.5.0.jar

# Copy nifi flow and configuration files
COPY nifi.properties /opt/nifi/nifi-current/conf/nifi.properties
COPY flow.xml.gz /opt/nifi/nifi-current/conf/flow.xml.gz

# Set environment variables for PostgreSQL connection
ENV POSTGRES_HOST postgres
ENV POSTGRES_PORT 5432
ENV POSTGRES_DB the_melvin_bank_db
ENV POSTGRES_USER admin
ENV POSTGRES_PASSWORD adminpassword

# Custom setup script
COPY scripts/setup.sh /opt/nifi/scripts/setup.sh
RUN chmod +x /opt/nifi/scripts/setup.sh && /opt/nifi/scripts/setup.sh

# Expose web interface and node port
EXPOSE 8080 8443

# Start Nifi service
ENTRYPOINT ["/opt/nifi/scripts/setup.sh"]