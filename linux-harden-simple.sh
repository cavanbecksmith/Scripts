#!/bin/bash

# Update package repositories and upgrade installed packages
echo "Updating package repositories and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y

# Install essential security tools
echo "Installing essential security tools..."
sudo apt install -y fail2ban ufw apparmor

# Enable firewall (UFW) and allow necessary services
echo "Configuring firewall (UFW)..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh  # Allow SSH connections
sudo ufw limit ssh  # Limit SSH connections
sudo ufw allow 80/tcp  # Allow HTTP traffic
sudo ufw allow 443/tcp  # Allow HTTPS traffic
sudo ufw status

# Configure Fail2Ban to protect against brute-force attacks
echo "Configuring Fail2Ban..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl restart fail2ban

# Disable root login and password authentication
echo "Disabling root login and password authentication..."
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Set up automatic security updates
echo "Configuring automatic security updates..."
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Enable automatic updates for installed packages
echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";' | sudo tee /etc/apt/apt.conf.d/20auto-upgrades

# Enable AppArmor
echo "Enabling AppArmor..."
sudo aa-enforce /etc/apparmor.d/*
sudo systemctl restart apparmor

echo "Security hardening completed!"
