#!/bin/bash
echo "Starting NiFi Setup..."

# Optional: Download custom processors or install NiFi extensions
if [ ! -d "/opt/nifi/nifi-current/extensions" ]; then
  mkdir -p /opt/nifi/nifi-current/extensions
fi

# Link properties file if needed
ln -sf /opt/nifi/nifi-current/conf/nifi.properties /opt/nifi/nifi-current/properties

echo "NiFi setup complete. Starting NiFi..."
exec /opt/nifi/nifi-current/bin/nifi.sh run