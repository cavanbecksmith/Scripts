#!/bin/bash

# Update the ClamAV database
freshclam

# Define directories to scan, quarantine location, and report location
HOME_DIR="/home"
QUARANTINE_DIR="/_avscans/quarantine"
REPORT_DIR="/_avscans/reports"
REPORT_FILE="$REPORT_DIR/clamscan_report_$(date +'%Y-%m-%d').txt"

# Create quarantine and report directories if they don't exist
mkdir -p "$QUARANTINE_DIR"
mkdir -p "$REPORT_DIR"

# Perform the scan and move infected files to quarantine
clamscan -r --move="$QUARANTINE_DIR" --log="$REPORT_FILE" "$HOME_DIR"
chmod 644 "$REPORT_FILE"

# Optional: Send the report via email (requires mailx to be installed)
# mail -s "Daily ClamAV Report" user@example.com < "$REPORT_FILE"
