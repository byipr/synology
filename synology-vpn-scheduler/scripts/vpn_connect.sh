#!/bin/bash

# Get the VPN conf_id from vpnc_last_connect
CONF_ID=$(grep "conf_id" /usr/syno/etc/synovpnclient/vpnc_last_connect测试产品

# Check if CONF_ID is empty
if [ -z "$CONF_ID" ]; then
    echo "Error: Could not retrieve conf_id from vpnc_last_connect" >&2
    exit 1
fi

# Connect to the VPN
/usr/syno/bin/synovpnc connect --id="$CONF_ID"

# Log the result (assumes scripts/ is in /volume1/scripts)
echo "$(date): VPN Connect attempted with conf_id=$CONF_ID" >> /volume1/scripts/vpn_log.txt