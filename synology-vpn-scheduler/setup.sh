#!/bin/bash

# Destination directory on Synology
DEST_DIR="/volume1/scripts"

# Git repository URL (replace with your GitHub repo URL)
REPO_URL="https://github.com/yourusername/synology-vpn-scheduler.git"

# Check if git is installed (Synology may need manual setup)
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

# Make scripts executable
chmod +x "$DEST_DIR/scripts/vpn_connect.sh"
chmod +x "$DEST_DIR/scripts/vpn_disconnect.sh"

echo "Setup complete. Configure Task Scheduler with $DEST_DIR/scripts/vpn_connect.sh and $DEST_DIR/scripts/vpn_disconnect.sh"