# Use a base Spark image with Scala support
FROM bitnami/spark:3.0.1

# Install Maven
USER root
RUN apt-get update && apt-get install -y ca-certificates-java && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Copy application files and download dependencies
COPY . /app/

# Run the Maven build and model training profile
RUN mvn clean install -Ptrain-model

# Build the JAR for the main application
RUN mvn package -DskipTests

# Set environment variables for Spark
ENV SPARK_MASTER_URL spark://spark-master:7077

# Copy entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
#ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["bash", "-c", "for i in {1500..1}; do echo \"$i\"; sleep 1; done "]