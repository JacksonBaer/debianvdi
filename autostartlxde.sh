# Add the required line to the user's autostart file
echo "@/usr/bin/bash /home/vdiuser/thinclient" > ~/.config/lxsession/LXDE/autostart

# Create thin client script
echo "Creating thinclient script..."
touch ~/thinclient

cat <<'EOL' > ~/thinclient
#!/bin/bash
# Navigate to the PVE-VDIClient directory
cd ~/PVE-VDIClient
# Run loop for thin client to prevent user closure
while true; do
    /usr/bin/python3 ~/PVE-VDIClient/vdiclient.py
done
EOL

# Make thinclient script executable
chmod +x ~/thinclient