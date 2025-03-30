#!/bin/bash

# Get the VPN conf_id from vpnc_last_connect
CONF_ID=$(grep "conf_id" /usr/syno/etc/synovpnclient/vpnc_last_connect | cut -d'=' -f2)

# Check if CONF_ID is empty
if [ -z "$CONF_ID" ]; then
    echo "Error: Could not retrieve conf_id from vpnc_last_connect" >&2
    exit 1
fi

# Disconnect the VPN
/usr/syno/bin/synovpnc kill_client --id="$CONF_ID"

# Optional: Double disconnect to prevent auto-reconnect
sleep 2
/usr/syno/bin/synovpnc kill_client --id="$CONF_ID"

# Optional: Log the result
echo "$(date): VPN Disconnect attempted with conf_id=$CONF_ID" >> /volume1/scripts/vpn_log.txt
