#!/bin/bash

# Capture the ID from the response
process_group_id=$(curl -s http://localhost:8080/nifi-api/flow/process-groups/root | jq -r '.processGroupFlow.id')

# Use the captured ID in the next command
echo "Captured process group ID: $process_group_id"

curl --location "http://localhost:8080/nifi-api/process-groups/$process_group_id/process-groups/upload" \
--header 'Content-Type: multipart/form-data' \
--form 'positionX="11.0"' \
--form 'clientId="4036074c-018c-1000-3e06-aaaaaaaaaaaa"' \
--form 'disconnectNode="true"' \
--form 'groupName="combineUsersAndTransactions"' \
--form 'positionY="557.0"' \
--form 'file=@"/opt/nifi/conf/combineUsersAndTransactions.json"' \
--insecure

# Get the list of all controller services
services=$(curl -s -X GET http://localhost:8080/nifi-api/resources | jq -r '.resources[] | select(.identifier | startswith("/controller-services/")) | .identifier | split("/") | .[-1]')

echo $services

# Loop through each service and start it
for service in $services; do
    echo "Starting controller service with ID: $service"
    curl -s -X PUT \
         -H "Content-Type: application/json" \
         -d '{"revision": {"version": 0}, "state": "ENABLED"}' \
         http://localhost:8080/nifi-api/controller-services/$service/run-status
done

echo "All controller services have been started."

# Get the process id of our process group
PROCESS_GROUP_NAME="combineUsersAndTransactions"
PROCESS_GROUP_ID=$(curl -s -X GET http://localhost:8080/nifi-api/process-groups/root/process-groups | jq -r --arg NAME "$PROCESS_GROUP_NAME" '.processGroups[] | select(.component.name == $NAME) | .id')

# Get the list of all processors in the specified process group
processors=$(curl -s -X GET http://localhost:8080/nifi-api/process-groups/"$PROCESS_GROUP_ID" | jq -c '.processGroupFlow.flow.processors[].id')

# Loop through each processor and start it
for processor in $processors; do
    echo "Starting processor with ID: $processor"
    curl -s -X PUT \
         -H "Content-Type: application/json" \
         -d '{"revision": {"version": 0}, "state": "RUNNING"}' \
         http://localhost:8080/nifi-api/processors/$processor/run-status
done

echo "All processors have been started."
