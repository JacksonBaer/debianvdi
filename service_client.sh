#!/bin/bash

# Thin Client Maintenance Script
# Compatible with Debian-based systems
# Author: Jackson Baer
# Date: 27 Nov 2024

#Establishes Log File
LOG_FILE="/var/log/thinclient_setup.log"

log_event() {
    echo "$(date): $1" >> /var/log/thinclient_setup.log
}

# Ensure the log file exists
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
     log_event "Log file created."
fi


log_event "Starting Thin Client Service script"


# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  log_event "User ID is $EUID. Exiting if not root."
  exit
fi

# Update and Upgrade System
echo "Updating and upgrading system..."
log_event "Updating and upgrading system..."
sudo apt-get update -y >> $LOGFILE 2>&1
sudo apt-get upgrade -y >> $LOGFILE 2>&1
echo "System update and upgrade completed." 
log_event "System update and upgrade completed." 

# Clean Up Unused Packages
echo "Cleaning up unused packages and cache..."
log_event "Cleaning up unused packages and cache..."
sudo apt-get autoremove -y >> $LOGFILE 2>&1
sudo apt-get autoclean -y >> $LOGFILE 2>&1
echo "Cleanup completed." 
log_event "Cleanup completed." 

# Check Disk Usage
echo "Checking disk usage..." 
log_event "Checking disk usage..." 

df -h 

# Remove Old Logs
echo "Rotating and cleaning old logs..."
log_event "Rotating and cleaning old logs..."
sudo logrotate -f /etc/logrotate.conf >> $LOGFILE 2>&1
find /var/log -type f -name "*.gz" -mtime +30 -exec rm -f {} \; >> $LOGFILE 2>&1
echo "Log cleanup completed." 

# Verify Running Services
echo "Checking systemd services..." 
sudo systemctl --failed 

# Check Memory Usage
echo "Checking memory usage..." 
free -h 

# Verify Disk Health (Requires `smartmontools`)
if command -v smartctl &> /dev/null; then
    echo "Running disk health check..." 
    sudo smartctl -H /dev/sda 
else
    echo "smartctl not installed. Skipping disk health check."
    log_event "smartctl not installed. Skipping disk health check."
fi

# Reboot Recommendation if Needed
echo "Checking if reboot is required..." 
if [ -f /var/run/reboot-required ]; then
    echo "Reboot required. Please reboot the system." 
else
    echo "No reboot required." 
fi

# End of Script
echo "Thin Client Maintenance Script Completed on $(date)" 
