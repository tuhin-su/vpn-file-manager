#!/bin/bash

# Set text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
clear
echo -e "${CYAN}"
echo "***********************************************"
echo "*                                             *"
echo "*      OpenVPN CLI Manager Installation       *"
echo "*                                             *"
echo "***********************************************"
echo -e "${NC}"

# Installation Information
echo -e "${YELLOW}Creation Date: ${NC}$(date)"
echo -e "${YELLOW}Developer: ${NC} tuhin-su"
echo ""

# Step 1: Install Dependencies
echo -e "${GREEN}Step 1: Installing Dependencies...${NC}"
echo -e "${CYAN}Updating package list and installing Python3, pip, and OpenVPN...${NC}"
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip openvpn

# Step 2: Install Python Rich Library
echo -e "${GREEN}Step 2: Installing Python Rich Library...${NC}"
python3 -m pip install rich

# Step 3: Creating the Default VPN Directory
VPN_DIRECTORY="${HOME}/.vpn"
if [ ! -d "$VPN_DIRECTORY" ]; then
    echo -e "${GREEN}Step 3: Creating Default VPN Directory at ${VPN_DIRECTORY}...${NC}"
    mkdir -p "$VPN_DIRECTORY"
    echo -e "${YELLOW}Default VPN directory created. Place your .ovpn files in this directory.${NC}"
else
    echo -e "${YELLOW}Default VPN directory already exists at ${VPN_DIRECTORY}.${NC}"
fi

# Step 4: Copy Python Script to /usr/local/bin
SCRIPT_NAME="vpn"
echo -e "${GREEN}Step 4: Copying Python script to /usr/local/bin as '${SCRIPT_NAME}'...${NC}"
sudo cp vpn /usr/local/bin/$SCRIPT_NAME
sudo chmod +x /usr/local/bin/$SCRIPT_NAME

# Installation Complete
echo -e "${GREEN}Installation Completed Successfully!${NC}"
echo -e "${CYAN}"
echo "***********************************************"
echo "*                                             *"
echo "*      OpenVPN CLI Manager is Ready!          *"
echo "*                                             *"
echo "* To get started, use the following command:  *"
echo "*                                             *"
echo "*   vpn --list                                *"
echo "*                                             *"
echo "* To connect to a VPN:                        *"
echo "*   vpn --connect <name>                      *"
echo "*                                             *"
echo "* To disconnect from VPN:                     *"
echo "*   vpn --disconnect                          *"
echo "*                                             *"
echo "***********************************************"
echo -e "${NC}"
