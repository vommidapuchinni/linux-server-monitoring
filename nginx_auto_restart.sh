#!/bin/bash
# Auto-restart NGINX if it is down

ALERT_FILE="/home/ubuntu/nginx_restart_alerts.log"

# Ensure alert file exists
touch "$ALERT_FILE"

# Check NGINX status
NGINX_STATUS=$(systemctl is-active nginx)

if [ "$NGINX_STATUS" != "active" ]; then
    echo "$(date): ALERT! NGINX server is DOWN" >> "$ALERT_FILE"
    
    # Attempt to restart NGINX
    sudo systemctl start nginx
    
    # Verify restart
    if systemctl is-active --quiet nginx; then
        echo "$(date): NGINX server restarted successfully" >> "$ALERT_FILE"
    else
        echo "$(date): FAILED to restart NGINX server" >> "$ALERT_FILE"
    fi
fi

