#!/bin/bash
# Automated server monitoring with proactive alerts

REPORT="/home/ubuntu/server_report_$(date '+%F_%H-%M-%S').txt"
ALERT_FILE="/home/ubuntu/alerts.log"

# Ensure alert file exists
touch "$ALERT_FILE"

# --- System Info ---
echo "===== SERVER REPORT =====" > $REPORT
echo "Date: $(date)" >> $REPORT
echo "Hostname: $(hostname)" >> $REPORT
uptime >> $REPORT

# --- CPU & Memory ---
echo -e "\n=== CPU & Memory ===" >> $REPORT
free -h >> $REPORT
top -b -n1 | head -10 >> $REPORT

# --- Disk Usage ---
echo -e "\n=== Disk Usage ===" >> $REPORT
df -h >> $REPORT

# --- Logged-in Users ---
echo -e "\n=== Logged-in Users ===" >> $REPORT
who >> $REPORT

# --- Failed SSH Login Alerts ---
FAIL_COUNT=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null)
FAIL_COUNT=${FAIL_COUNT:-0}  # Ensure numeric
if [ "$FAIL_COUNT" -gt 5 ]; then
  echo "$(date): ALERT! $FAIL_COUNT failed login attempts" >> "$ALERT_FILE"
fi

# --- NGINX Status Alert ---
NGINX_STATUS=$(systemctl is-active nginx)
if [ "$NGINX_STATUS" != "active" ]; then
    echo "$(date): ALERT! NGINX server is DOWN" >> "$ALERT_FILE"
fi

# --- CPU Usage Alert ---
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4}')
CPU_INT=${CPU_USAGE%.*}  # convert to integer
if [ "$CPU_INT" -gt 80 ]; then
    echo "$(date): ALERT! High CPU usage: $CPU_INT%" >> "$ALERT_FILE"
fi

# --- Disk Usage Alert ---
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "$(date): ALERT! High Disk usage: $DISK_USAGE%" >> "$ALERT_FILE"
fi

# --- Report Saved ---
echo "Report saved: $REPORT"

