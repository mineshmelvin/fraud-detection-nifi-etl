# Dockerfile for NiFi
FROM apache/nifi:1.14.0

# Install PostgreSQL JDBC Driver
RUN curl -L -o /opt/nifi/nifi-current/lib/postgresql-jdbc.jar https://jdbc.postgresql.org/download/postgresql-42.5.0.jar

# Copy nifi flow and configuration files
COPY nifi.properties /opt/nifi/nifi-current/conf/nifi.properties
COPY nifi.properties /opt/nifi/conf/nifi.properties
COPY data/processors/combineUsersAndTransactions.json /opt/nifi/conf/combineUsersAndTransactions.json
COPY data/processors/sendEmailAboutFraud.json /opt/nifi/conf/sendEmailAboutFraud.json
COPY ./scripts/import-flow.sh /opt/nifi/scripts/import-flow.sh
COPY ./scripts/setup.sh /opt/nifi/scripts/setup.sh

# Set environment variables for PostgreSQL connection
ENV POSTGRES_HOST postgres
ENV POSTGRES_PORT 5432
ENV POSTGRES_DB the_melvin_bank_db
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD adminpassword

# Custom setup script
USER root
# Create logs directory (if it doesn't exist) and set permissions
RUN mkdir -p /opt/nifi/nifi-current/logs && \
    chown -R nifi:nifi /opt/nifi/nifi-current/logs

# Copy scripts
RUN ls /opt/nifi

# Set executable permissions for scripts
RUN chmod +x /opt/nifi/scripts/setup.sh /opt/nifi/scripts/import-flow.sh

# Switch back to the nifi user
USER nifi

# Expose web interface and node port
EXPOSE 8080 8443

# Start NiFi service
# RUN /opt/nifi/nifi-current/bin/nifi.sh start
#ENTRYPOINT ["bash", "-c", "/opt/nifi/nifi-current/bin/nifi.sh run "]
ENTRYPOINT ["bash", "-c", "/opt/nifi/scripts/setup.sh && for i in {150..1}; do echo \"$i\"; sleep 1; done && /opt/nifi/scripts/import-flow.sh"]