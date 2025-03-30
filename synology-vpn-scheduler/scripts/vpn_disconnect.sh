#!/bin/bash

# Disconnect VPN with hardcoded conf_id (to be populated by setup.sh)
/usr/syno/bin/synovpnc kill_client --id=<CONF_ID>

# Log the result
echo "VPN Disconnected" >> /volume1/scripts/synology/synology-vpn-scheduler/vpn_log.txt