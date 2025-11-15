#!/bin/bash
# Uninstall monitor_client

# Stop and disable service
sudo systemctl stop monitor_client
sudo systemctl disable monitor_client

# Remove files
sudo rm -rf /opt/monitor_client
sudo rm /usr/lib/systemd/system/monitor_client.service

# Reload systemd
sudo systemctl daemon-reload

echo "Monitor client uninstalled."
