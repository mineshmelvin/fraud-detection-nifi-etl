#!/bin/bash
/opt/bitnami/spark/bin/spark-submit \
    --class com.melvin.FraudDetector \
    --master local[*] \
    --packages com.datastax.spark:spark-cassandra-connector_2.12:3.0.1 \
    /app/target/FraudDetection-1.0-SNAPSHOT.jar