#!/bin/bash

# Directory for scripts and logs
SCRIPT_DIR="/volume1/scripts/synology/synology-vpn-scheduler/scripts"
LOG_FILE="/volume1/scripts/synology/synology-vpn-scheduler/vpn_log.txt"

# Log initial state
echo "$(date): Starting VPN disconnect script" >> "$LOG_FILE"

# Check if vpnc_last_connect exists and log its contents
if [ ! -f /usr/syno/etc/synovpnclient/vpnc_last_connect ]; then
    echo "$(date): Warning: vpnc_last_connect file not found" >> "$LOG_FILE"
else
    echo "$(date): vpnc_last_connect contents: $(cat /usr/syno/etc/synovpnclient/vpnc_last_connect)" >> "$LOG_FILE"
fi

# Get conf_id from vpnc_last_connect (optional, for logging)
CONF_ID=$(grep "conf_id" /usr/syno/etc/synovpnclient/vpnc_last_connect | cut -d'=' -f2)
if [ -z "$CONF_ID" ]; then
    echo "$(date): No conf_id found; proceeding with generic disconnect" >> "$LOG_FILE"
else
    echo "$(date): Found conf_id: $CONF_ID" >> "$LOG_FILE"
fi

# Log status before disconnect
echo "$(date): VPN status before disconnect: $(synovpnc status)" >> "$LOG_FILE"

# Disconnect VPN (generic, no --id needed)
synovpnc kill_client

# Double disconnect to prevent auto-reconnect
sleep 2
synovpnc kill_client

# Check disconnection status
sleep 5
STATUS=$(synovpnc status)
echo "$(date): VPN status after disconnect: $STATUS" >> "$LOG_FILE"

if echo "$STATUS" | grep -q "disconnected\|not running\|stopped"; then
    echo "$(date): VPN disconnected successfully (conf_id=${CONF_ID:-unknown})" >> "$LOG_FILE"
else
    echo "$(date): VPN disconnection failed (conf_id=${CONF_ID:-unknown})" >> "$LOG_FILE"
    exit 1
fi