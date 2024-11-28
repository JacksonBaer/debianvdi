#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Prompt for the Proxmox IP or DNS name
read -p "Enter the Proxmox IP or DNS name: " PROXMOX_IP

# Prompt for the Thin Client Title
read -p "Enter the Thin Client Title: " VDI_TITLE
# Create the configuration directory and file
echo "Setting up configuration..."
sudo mkdir -p /etc/vdiclient
sudo tee /etc/vdiclient/vdiclient.ini > /dev/null <<EOL
[General]

title = $VDI_TITLE
icon=vdiicon.ico
logo=vdilogo.png
kiosk=false

[Authentication]
auth_backend=pve
auth_totp=false
tls_verify=false

[Hosts]
$PROXMOX_IP=8006
EOL

echo " If this is your initial installation of the VDI client, Please wait to restart the client"
echo " You will need to Cat the contents of the newly created "license.txt" file from the client device and manually open the vdiclient.py file and register the gui backend"
read -p "Configuration complete. Do you want to restart the system now? (y/n): " RESTART
if [[ "$RESTART" =~ ^[Yy]$ ]]; then
  echo "Restarting the system..."
  sudo reboot
else
  echo "Please reboot the system manually to apply changes."
fi