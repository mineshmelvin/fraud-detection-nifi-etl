# Use a base Spark image with Scala support
FROM bitnami/spark:latest

# Set up working directory
WORKDIR /app

# Copy SBT configuration
COPY build.sbt .
RUN mkdir -p src/main/scala

# Copy application files
COPY src/main/scala /app/src/main/scala
COPY GeoLite2-City.mmdb /app/GeoLite2-City.mmdb

# Set environment variables for Spark
ENV SPARK_MASTER_URL spark://spark-master:7077
ENV KAFKA_BOOTSTRAP_SERVERS kafka:9092

# Install dependencies via SBT and create assembly
RUN /opt/spark/bin/spark-shell --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2

# Copy entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]