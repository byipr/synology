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
STATUS_BEFORE=$(/usr/syno/bin/synovpnc get_conn)
echo "$(date): VPN status before disconnect: $STATUS_BEFORE" >> "$LOG_FILE"

# Disconnect VPN (generic, no --id needed)
if echo "$STATUS_BEFORE" | grep -q "connected"; then
    /usr/syno/bin/synovpnc kill_client
    # Double disconnect to prevent auto-reconnect
    sleep 2
    /usr/syno/bin/synovpnc kill_client
else
    echo "$(date): VPN not connected before attempt; proceeding anyway" >> "$LOG_FILE"
    /usr/syno/bin/synovpnc kill_client
    sleep 2
    /usr/syno/bin/synovpnc kill_client
fi

# Check disconnection status
sleep 5
STATUS_AFTER=$(/usr/syno/bin/synovpnc get_conn)
echo "$(date): VPN status after disconnect: $STATUS_AFTER" >> "$LOG_FILE"

# Check if disconnected or already off
if echo "$STATUS_AFTER" | grep -q "disconnected\|not connected\|no connection\|No VPN connection"; then
    echo "$(date): VPN disconnected successfully (conf_id=${CONF_ID:-unknown})" >> "$LOG_FILE"
elif echo "$STATUS_BEFORE" | grep -q "disconnected\|not connected\|no connection\|No VPN connection"; then
    echo "$(date): VPN was already disconnected; treating as success (conf_id=${CONF_ID:-unknown})" >> "$LOG_FILE"
else
    echo "$(date): VPN disconnection failed (conf_id=${CONF_ID:-unknown})" >> "$LOG_FILE"
    exit 1
fi