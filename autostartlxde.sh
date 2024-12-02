#!/bin/bash
# Thin Client Enable on Boot
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


log_event "Starting AutoLXDE Setup script"


# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  log_event "User ID is $EUID. Exiting if not root."
  exit
fi

# Add the required line to the user's autostart file
echo "@/usr/bin/bash /home/vdiuser/thinclient" > /home/vdiuser/.config/lxsession/LXDE/autostart

# Create thin client script
echo "Creating thinclient script..."
log_event "Creating thinclient script"
touch /home/vdiuser/thinclient

cat <<'EOL' > /home/vdiuser/thinclient
#!/bin/bash
sleep 1
/usr/bin/openbox --exit
# Navigate to the PVE-VDIClient directory
cd ~/PVE-VDIClient
# Run loop for thin client to prevent user closure
while true; do
    /usr/bin/python3 ~/PVE-VDIClient/vdiclient.py
done
EOL

# Make thinclient script executable
log_event "Making ~/thinclient Bootable"
chmod +x ~/thinclient
#Restarting the client
log_event "Rebooting System to Apply Changes"
sudo reboot