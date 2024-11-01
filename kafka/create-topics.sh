#!/bin/bash

# Define topics and configurations
TOPICS=("transactions" "fraud_alerts" "processed_transactions")

for topic in "${TOPICS[@]}"
do
  kafka-topics.sh --create --topic $topic \
               --bootstrap-server kafka:9093 \
               --replication-factor 1 \
               --partitions 3 \
               --if-not-exists
done

# Optional: describe to verify
kafka-topics.sh --describe --bootstrap-server kafka:9093