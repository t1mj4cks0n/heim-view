#!/bin/bash
# Update monitor_client safely
set -euo pipefail

INSTALL_DIR="/opt/monitor_client"
SCRIPT_NAME="monitor_client.py"
CONFIG_FILE="$INSTALL_DIR/config.json"
LOG_FILE="$INSTALL_DIR/logs/update.log"
GITHUB_REPO="${1:-https://raw.githubusercontent.com/t1mj4cks0n/monitor_client/main/monitor_client}"

# Log actions
exec >> "$LOG_FILE" 2>&1
echo "=== Update started at $(date) ==="

# Download new script
echo "Downloading new version of $SCRIPT_NAME..."
if ! curl -s -o "/tmp/$SCRIPT_NAME" "$GITHUB_REPO/$SCRIPT_NAME"; then
    echo "ERROR: Failed to download $SCRIPT_NAME"
    exit 1
fi

# Verify download
if [ ! -f "/tmp/$SCRIPT_NAME" ]; then
    echo "ERROR: Downloaded file not found"
    exit 1
fi

# Stop the service
echo "Stopping monitor_client service..."
if ! systemctl stop monitor_client; then
    echo "ERROR: Failed to stop service"
    exit 1
fi

# Backup config
echo "Backing up config..."
cp "$CONFIG_FILE" "/tmp/config.json.backup"

# Replace script
echo "Installing new script..."
if ! mv "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"; then
    echo "ERROR: Failed to replace script"
    systemctl start monitor_client  # Restart old version if update fails
    exit 1
fi

# Restore config
echo "Restoring config..."
mv "/tmp/config.json.backup" "$CONFIG_FILE"

# Set permissions
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Restart service
echo "Starting monitor_client service..."
if ! systemctl start monitor_client; then
    echo "ERROR: Failed to start service"
    exit 1
fi

echo "Update completed successfully at $(date)"
exit 0
