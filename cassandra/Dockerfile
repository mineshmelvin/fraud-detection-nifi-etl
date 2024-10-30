# Cassandra Dockerfile
FROM cassandra:latest

# Optional: You can add any custom configurations or initialization scripts here
COPY ./init.cql /docker-entrypoint-initdb.d/

# This entrypoint is provided by the cassandra image.