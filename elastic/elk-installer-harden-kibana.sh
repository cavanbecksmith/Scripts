#!/bin/bash

# Update package repositories and upgrade installed packages
echo "Updating package repositories and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y

# Install essential security tools and ELK stack components
echo "Installing essential security tools and ELK stack components..."
sudo apt install -y fail2ban ufw apparmor openjdk-11-jdk apt-transport-https gnupg2 wget
# Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update && sudo apt install -y elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
# Kibana
sudo apt install -y kibana
sudo systemctl enable kibana
sudo systemctl start kibana

# Enable firewall (UFW) and allow necessary services
echo "Configuring firewall (UFW)..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh  # Allow SSH connections
sudo ufw limit ssh  # Limit SSH connections
sudo ufw allow 80/tcp  # Allow HTTP traffic
sudo ufw allow 443/tcp  # Allow HTTPS traffic
sudo ufw allow 5601/tcp  # Allow Kibana traffic
sudo ufw status

# Configure Fail2Ban to protect against brute-force attacks
echo "Configuring Fail2Ban..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl restart fail2ban

# Set password complexity rules
echo "Configuring password complexity rules..."
sudo apt install -y libpam-pwquality
sudo sed -i '/password\s*requisite\s*pam_pwquality.so/c\password requisite pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1' /etc/pam.d/common-password

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

echo "ELK stack, security hardening, and password rules configured!"
