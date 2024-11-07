#!/bin/bash

# Specify the domain and IP address pairs
entries=(
    "127.0.0.1   test.local"
    #"127.0.0.1   your-local-domain-2.com"
    # Add more entries as needed
)

# Specify the path to the hosts file
hostsFilePath="/etc/hosts"

# Check if the script is running with elevated privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Add entries to the hosts file
for entry in "${entries[@]}"; do
    echo "$entry" >> "$hostsFilePath"
done

echo "Hosts file updated successfully."
