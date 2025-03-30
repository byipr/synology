#!/bin/bash

# Destination directory on Synology (root of the repo)
DEST_DIR="/volume1/scripts/synology"

# Git repository URL
REPO_URL="https://github.com/byipr/synology.git"

# Check if running from within the repo
if [ -d "$(dirname "$0")/.git" ]; then
    echo "Already in a Git repo, skipping clone..."
    SCRIPT_DIR="$(dirname "$0")"
else
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Please install Git or manually download the repo."
        exit 1
    fi

    # Clone or pull the repository
    if [ -d "$DEST_DIR/.git" ]; then
        echo "Pulling latest changes..."
        cd "$DEST_DIR" && git pull
    else
        echo "Cloning repository..."
        git clone "$REPO_URL" "$DEST_DIR"
    fi
    SCRIPT_DIR="$DEST_DIR/synology-vpn-scheduler"
fi

# Extract conf_id with sudo
CONF_ID=$(sudo grep "conf_id" /usr/syno/etc/synovpnclient/vpnc_last_connect | cut -d'=' -f2)
if [ -z "$CONF_ID" ]; then
    echo "Error: Could not retrieve conf_id. Please connect the VPN manually first via DSM GUI."
    exit 1
fi

# Populate conf_id into vpn_connect.sh and vpn_disconnect.sh using sed
sudo sed -i "s/<CONF_ID>/$CONF_ID/g" "$SCRIPT_DIR/scripts/vpn_connect.sh"
sudo sed -i "s/<CONF_ID>/$CONF_ID/g" "$SCRIPT_DIR/scripts/vpn_disconnect.sh"

# Make scripts executable
chmod +x "$SCRIPT_DIR/scripts/vpn_connect.sh"
chmod +x "$SCRIPT_DIR/scripts/vpn_disconnect.sh"

echo "Setup complete. Configured with conf_id=$CONF_ID"
echo "Configure Task Scheduler with $SCRIPT_DIR/scripts/vpn_connect.sh and $SCRIPT_DIR/scripts/vpn_disconnect.sh"