#!/bin/bash

# Create vpnc_connecting file with hardcoded conf_id (to be populated by setup.sh)
cat > /usr/syno/etc/synovpnclient/vpnc_connecting <<END
conf_id=<CONF_ID>
conf_name=MyVPN
proto=openvpn
END

# Connect to VPN
/usr/syno/bin/synovpnc connect --id=<CONF_ID>

# Log the result
echo "VPN Connected" >> /volume1/scripts/synology/synology-vpn-scheduler/vpn_log.txt