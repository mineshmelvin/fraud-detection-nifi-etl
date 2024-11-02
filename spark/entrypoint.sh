#!/bin/bash
echo "Starting Spark job with Scala..."
/opt/bitnami/spark/bin/spark-submit \
    --class com.melvin.FraudDetector \
    --master local[*] \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.1,com.datastax.spark:spark-cassandra-connector_2.12:3.0.1,io.dropwizard.metrics:metrics-core:4.2.16 \
    /app/target/FraudDetection-1.0-SNAPSHOT.jar
