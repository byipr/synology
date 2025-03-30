#!/bin/bash

# Directory for scripts and logs
SCRIPT_DIR="/volume1/scripts/synology/synology-vpn-scheduler/scripts"
LOG_FILE="/volume1/scripts/synology/synology-vpn-scheduler/vpn_log.txt"

# Get conf_id from vpnc_last_connect
CONF_ID=$(grep "conf_id" /usr/syno/etc/synovpnclient/vpnc_last_connect | cut -d'=' -f2)
CONF_NAME=$(grep "conf_name" /usr/syno/etc/synovpnclient/vpnc_last_connect | cut -d'=' -f2)
PROTO=$(grep "proto" /usr/syno/etc/synovpnclient/vpnc_last_connect | cut -d'=' -f2)

# Check if conf_id is empty
if [ -z "$CONF_ID" ]; then
    echo "$(date): Error: Could not retrieve conf_id from vpnc_last_connect" >> "$LOG_FILE"
    exit 1
fi

# Create vpnc_connecting file (requires root)
cat > /usr/syno/etc/synovpnclient/vpnc_connecting <<END
conf_id=$CONF_ID
conf_name=$CONF_NAME
proto=$PROTO
END

# Connect to VPN (requires root)
synovpnc connect --id="$CONF_ID"

# Check connection status
sleep 5  # Give it a moment to connect
if synovpnc status | grep -q "connected"; then
    echo "$(date): VPN connected successfully (conf_id=$CONF_ID)" >> "$LOG_FILE"
else
    echo "$(date): VPN connection failed (conf_id=$CONF_ID)" >> "$LOG_FILE"
    exit 1
fi