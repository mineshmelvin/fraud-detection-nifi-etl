#!/bin/bash
echo "Starting Spark job with Scala..."
/opt/spark/bin/spark-submit \
    --class Main \
    --master local[*] \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2 \
    /app/target/scala-2.12/fraud-detection.jar