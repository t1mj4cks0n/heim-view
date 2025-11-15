# heim-view
simple monitoring app of debian/ubuntu servers


/opt/monitor_client/
├── monitor_client.py      # Main script (read-only after install)
├── config.json            # User-edited config
├── logs/
│   └── monitor_client.log # Logs
├── cache/
│   └── public_ip_cache.json
/usr/lib/systemd/system/monitor_client.service
/usr/local/bin/update_monitor_client.sh  # Update script (root-owned)
