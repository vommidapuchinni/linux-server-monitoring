# Linux Server Monitoring & Auto-Healing Project 🚀

## 📌 Overview
This project demonstrates an **automated Linux server monitoring and self-healing setup** using **Bash scripts, cron jobs, and AWS EC2**.  

It covers:  
- Automated **system reports** (CPU, memory, disk, users, logs)  
- **Failed SSH login alerts**  
- **NGINX monitoring & auto-restart** when service is down  
- Logging alerts in `alerts.log` and `nginx_restart_alerts.log`  
- Role-based **Linux users & groups** for team workflows  

---

## 🏗️ Infrastructure  
![Infrastructure Diagram](infrastructure.png)  

---

## ⚙️ Scripts  

- `server_monitor.sh` → Monitors system metrics, SSH login failures, generates reports.  
- `nginx_auto_restart.sh` → Checks NGINX status and restarts automatically if down.  

---

## ☁️ Step 1: Launch EC2 & Connect  

- Launch **Ubuntu 22.04 LTS (t2.micro)** instance  
- Security Group → allow SSH(22), HTTP(80)  
- Connect using SSH
![EC2 Instance](screenshots/ec2-instance.png)
![SSH Connection](screenshots/ssh.png)

## Step 2: Linux Users & Groups Setup

This project also demonstrates **creating Linux users and groups**, which is essential for team-based DevOps workflows.

### 1. Create Groups
sudo groupadd developers
sudo groupadd testers
getent group developers → Verify group exists
getent group testers → Verify group exists

### 2. Create Users and Assign to Groups
#### Developer user
sudo useradd -m -s /bin/bash -G developers dev1
sudo passwd dev1                                              # set password
#### Tester user
sudo useradd -m -s /bin/bash -G testers test1
sudo passwd test1                                              # set password

### 3. Test Users
sudo su - dev1   # switch to dev1
whoami           # outputs: dev1
exit             # back to main user

![Create user and group](screenshots/user&gropucreation.png)

---

## 🖥️ Step 3: Manual Linux Audit
Run basic Linux commands to check system details.
### System Info 
uname -a && hostnamectl && uptime
![System Info](screenshots/system-info.png)

### CPU & Memory
top -b -n1 | head -15 && free -h && df -h && du -sh /home/*
![CPU & Memory](screenshots/cpu-memory.png)

### Users & Groups
who && w && last && getent passwd 
![Users](screenshots/users.png)
getent group
![Groups](screenshots/groups.png)

### Services & Processes
systemctl list-units --type=service --state=running
![Services](screenshots/services-1.png)
ps aux | sort -nrk 3 | head -10
![Processes](screenshots/services-2.png)

### Network
ss -tulnp && ip a && ping -c 3 google.com
![Network](screenshots/network.png)

### File Permissions
ls -l /home && find /home -type f -perm /o+w && stat /etc/passwd
![Permissions](screenshots/permissions.png)

### Logs
tail -n 20 /var/log/auth.log
![authlogs](screenshots/logs-1.png)
grep "Failed password" /var/log/auth.log && journalctl -xe | head -20
![journal](screenshots/logs-2.png)

## 🔧 Step 3: Install & Monitor NGINX
Install NGINX
![Nginx installation](screenshots/nginx-installation.png)
Verify active and stopped states
![Nginx active](screenshots/nginx-active.png)
![Nginx inactive](screenshots/.nginx-stoppedandinactive.png)

## ⏱️ Step 4: Bash Scripts
### server_monitor.sh
Monitors CPU, memory, disk usage
Checks logged-in users
Detects failed SSH login attempts
Saves report in /home/ubuntu/server_report_*.txt
Logs alerts in alerts.log
![Server Report](screenshots/system-report.png)
### nginx_auto_restart.sh
Checks if NGINX is running
Restarts NGINX if down
Logs actions in nginx_restart_alerts.log

## ⏱️ Step 5: Cron Job Setup
Automates running scripts every 2 minutes:
crontab -e
#### Add lines:
*/2 * * * * /home/ubuntu/server_monitor.sh >> /home/ubuntu/server_monitor_cron.log 2>&1
*/2 * * * * /home/ubuntu/nginx_auto_restart.sh >> /home/ubuntu/nginx_auto_restart_cron.log 2>&1
![Cron setup](screenshots/cronsetup.png)
![Alerts & Cron Logs](screenshots/alertandcronlogs.png)

## Outcome
1. Automated Linux server monitoring and alerts
2. NGINX self-healing with auto-restart
3. Team-based Linux user/group setup demonstrating DevOps best practices
