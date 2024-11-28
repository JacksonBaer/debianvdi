#!/bin/bash
# Modify Thin Client Ini Config
# Compatible with Debian-based systems
# Author: Jackson Baer
# Date: 27 Nov 2024
# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Prompt for the Proxmox IP or DNS name
read -p "Enter the Proxmox IP or DNS name: " PROXMOX_IP

# Prompt for the Thin Client Title
read -p "Enter the Thin Client Title: " VDI_TITLE
#Prompt For Authentification Method for client
read -p "Enter Your Preferred Authentication Method {PVE, PAM}: " VDI_AUTH
 
while true; do
    read -p "Enter authentication type (PVE or PAM): " VDI_AUTH
    if [ "$VDI_AUTH" == "PVE" ] || [ "$VDI_AUTH" == "PAM" ]; then
        echo "You selected $VDI_AUTH authentication."
        break  # Exit the loop when a valid input is provided
    else
        echo "Error: Invalid input. Please enter 'PVE' or 'PAM'."
    fi
done

# Create the configuration directory and file
echo "Setting up configuration..."
# Create the configuration directory and file
echo "Setting up configuration..."

sudo tee /etc/vdiclient/vdiclient.ini > /dev/null <<EOL
[General]

title = $VDI_TITLE
icon=vdiicon.ico
logo=vdilogo.png
kiosk=false

[Authentication]
auth_backend=$VDI_AUTH
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