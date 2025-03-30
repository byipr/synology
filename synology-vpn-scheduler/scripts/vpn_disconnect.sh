#!/bin/bash

# Directory for scripts and logs
SCRIPT_DIR="/volume1/scripts/synology/synology-vpn-scheduler/scripts"
LOG_FILE="/volume1/scripts/synology/synology-vpn-scheduler/vpn_log.txt"

# Get conf_id from vpnc_last_connect
CONF_ID=$(grep "conf_id" /usr/syno/etc/synovpnclient/vpnc_last_connect | cut -d'=' -f2)

# Check if conf_id is empty
if [ -z "$CONF_ID" ]; then
    echo "$(date): Error: Could not retrieve conf_id from vpnc_last_connect" >> "$LOG_FILE"
    exit 1
fi

# Disconnect VPN (requires root)
synovpnc kill_client --id="$CONF_ID"

# Double disconnect to prevent auto-reconnect
sleep 2
synovpnc kill_client --id="$CONF_ID"

# Check disconnection status
sleep 5
if synovpnc status | grep -q "disconnected"; then
    echo "$(date): VPN disconnected successfully (conf_id=$CONF_ID)" >> "$LOG_FILE"
else
    echo "$(date): VPN disconnection failed (conf_id=$CONF_ID)" >> "$LOG_FILE"
    exit 1
fi