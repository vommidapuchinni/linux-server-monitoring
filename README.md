# Linux Server Monitoring & Auto-Restart Project

This project demonstrates an automated server monitoring system using **Linux commands, Bash scripting, and cron**. It includes:

- Automated **system reports** with CPU, memory, disk, and user info
- **Failed SSH login alerts**
- **NGINX server monitoring and auto-restart**
- Alerts logged in `alerts.log` and `nginx_restart_alerts.log`
- Cron-based automation for continuous monitoring

---

## Scripts

- `server_monitor.sh` – Monitors system metrics and logs alerts
- `nginx_auto_restart.sh` – Checks NGINX status and restarts if down

---

## Linux Users & Groups Setup

This project also demonstrates **creating Linux users and groups**, which is essential for team-based DevOps workflows.

### 1. Create Groups

sudo groupadd developers
sudo groupadd testers

getent group developers → Verify group exists

getent group testers → Verify group exists

### 2. Create Users and Assign to Groups

#### Developer user
sudo useradd -m -s /bin/bash -G developers dev1
sudo passwd dev1       # set password

#### Tester user
sudo useradd -m -s /bin/bash -G testers test1
sudo passwd test1      # set password

### 3. Test Users
sudo su - dev1   # switch to dev1
whoami           # outputs: dev1
exit             # back to main user

---

## Make scripts executable: chmod +x server_monitor.sh nginx_auto_restart.sh

## Test manually: 
./server_monitor.sh
./nginx_auto_restart.sh

## Setup cron for automation:
crontab -e
# Add:
*/2 * * * * /home/ubuntu/server_monitor.sh >> /home/ubuntu/server_monitor_cron.log 2>&1
*/2 * * * * /home/ubuntu/nginx_auto_restart.sh >> /home/ubuntu/nginx_auto_restart_cron.log 2>&1

## Outcome

1. Automated Linux server monitoring and alerts
2. NGINX self-healing with auto-restart
3. Team-based Linux user/group setup demonstrating DevOps best practices
