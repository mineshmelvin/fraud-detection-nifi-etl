#!/bin/bash
echo "Starting NiFi Setup..."

# Optional: Download custom processors or install NiFi extensions
if [ ! -d "/opt/nifi/nifi-current/extensions" ]; then
  mkdir -p /opt/nifi/nifi-current/extensions
fi

# Link properties file if needed
ln -sf /opt/nifi/nifi-current/conf/nifi.properties /opt/nifi/nifi-current/properties

# Start Nifi
/opt/nifi/nifi-current/bin/nifi.sh start

# Wait for Nifi to start
for i in {250..1}; do
  echo "$i";
  sleep 1
done

/opt/nifi/scripts/import-flow.sh
#/opt/nifi/nifi-current/bin/nifi.sh run && \
exec tail -f /dev/null

# Run NiFi in the foreground to keep the container alive
#exec /opt/nifi/nifi-current/bin/nifi.sh run