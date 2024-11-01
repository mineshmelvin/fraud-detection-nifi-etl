# Use a base Spark image with Scala support
FROM bitnami/spark:latest

# Install Maven
USER root
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline
RUN mkdir -p src/main/scala

# Copy application files
COPY src/main/scala /app/src/main/scala
COPY src/main/resources /app/src/main/resources

# Run the Maven build and model training profile
RUN mvn clean install -Ptrain-model

# Build the JAR for the main application
RUN mvn package -DskipTests

# Set environment variables for Spark
ENV SPARK_MASTER_URL spark://spark-master:7077
ENV KAFKA_BOOTSTRAP_SERVERS kafka:9092

# Copy entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]