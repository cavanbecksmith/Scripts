#!/bin/bash

# Default variable values
REMOTE_DIR=""
LOCAL_DIR=""
REMOTE_FILE_PATTERN="*"  # Match all files and folders in the directory

SSH_REFERENCE=""  # Reference to SSH key name or host name
SSH_USERNAME=""
SSH_PASSWORD=""  # Not recommended to hardcode; use securely in production
SSH_CONF_FOLDER="/home/$USER/.ssh/config"

COMPRESSION_FORMAT="7z"  # Change to .zip or .tar if desired
ARCHIVE_NAME=""
USE_PASSWORD_AUTH=false  # Default is key-based auth

: <<'EOF'
# Example command
bash ssh_download.sh run \
            --remote-dir "/home/user/folder" \
            --local-dir "/deadbox/_scripts" \
            --ssh-reference "rsa_key_name" \
            --username "user" \
            --config-folder "/home/user/.ssh/config" \
            --compression-format "7z" \
            --pattern "*" \
            --archive-name "backup_archive.7z"
            #--use-password-auth \
            #--password "secure_password"
EOF


# Usage message
usage() {
    echo "Usage: $0 [options]
Options:
  -r, --remote-dir            Remote directory to compress
  -l, --local-dir             Local directory to store the compressed file
  -p, --pattern               File pattern to match in remote directory
  -s, --ssh-reference         SSH reference (key name or host name)
  -u, --username              SSH username
  -w, --password              SSH password (use securely in production)
  -c, --config-folder         Path to SSH config folder
  -f, --compression-format    Compression format (7z, zip, tar)
  -a, --archive-name          Archive file name
  -P, --use-password-auth     Set to true to use password authentication
  -h, --help                  Show this help message
"
    exit 1
}

# Parse flags and set variables
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--remote-dir) REMOTE_DIR="$2"; shift ;;
        -l|--local-dir) LOCAL_DIR="$2"; shift ;;
        -p|--pattern) REMOTE_FILE_PATTERN="$2"; shift ;;
        -s|--ssh-reference) SSH_REFERENCE="$2"; shift ;;
        -u|--username) SSH_USERNAME="$2"; shift ;;
        -w|--password) SSH_PASSWORD="$2"; shift ;;
        -c|--config-folder) SSH_CONF_FOLDER="$2"; shift ;;
        -f|--compression-format) COMPRESSION_FORMAT="$2"; ARCHIVE_NAME="your_file_compressed.${COMPRESSION_FORMAT}"; shift ;;
        -a|--archive-name) ARCHIVE_NAME="$2"; shift ;;
        -P|--use-password-auth) USE_PASSWORD_AUTH=true ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Step 1: SSH into the remote server, check if files/folders exist, and compress them
echo "Checking if files/folders exist on remote server..."

if [ "$USE_PASSWORD_AUTH" = true ]; then
    # Password-based authentication
    sshpass -p "$SSH_PASSWORD" ssh "$SSH_USERNAME@$SSH_REFERENCE" "
        cd $REMOTE_DIR
        if compgen -G \"$REMOTE_FILE_PATTERN\" > /dev/null; then
            echo 'Files and/or folders found. Proceeding with compression...'
            7z a $ARCHIVE_NAME $REMOTE_FILE_PATTERN
        else
            echo 'No matching files or folders found. Exiting.'
            exit 1
        fi
    "
else
    # Key-based authentication
    ssh "$SSH_REFERENCE" "
        cd $REMOTE_DIR
        if compgen -G \"$REMOTE_FILE_PATTERN\" > /dev/null; then
            echo 'Files and/or folders found. Proceeding with compression...'
            7z a $ARCHIVE_NAME $REMOTE_FILE_PATTERN
        else
            echo 'No matching files or folders found. Exiting.'
            exit 1
        fi
    "
fi

# Check if compression was successful
if [ $? -eq 0 ]; then
    echo "Compression successful. Proceeding to next step."
else
    echo "Compression failed. Exiting."
    exit 1
fi

# Step 2: Use rsync to transfer the compressed file to the local machine
echo "Transferring compressed file to local machine using rsync..."

if [ "$USE_PASSWORD_AUTH" = true ]; then
    sshpass -p "$SSH_PASSWORD" rsync -avz -e "ssh -F $SSH_CONF_FOLDER" "$SSH_USERNAME@$SSH_REFERENCE:$REMOTE_DIR/$ARCHIVE_NAME" "$LOCAL_DIR"
else
    rsync -avz -e "ssh -F $SSH_CONF_FOLDER" "$SSH_REFERENCE:$REMOTE_DIR/$ARCHIVE_NAME" "$LOCAL_DIR"
fi

# Check if rsync transfer was successful
if [ $? -eq 0 ]; then
    echo "Transfer successful!"
else
    echo "Transfer failed. Exiting."
    exit 1
fi

# Step 3: Optional - Clean up remote server after transfer (remove the compressed file)
echo "Cleaning up remote server..."
if [ "$USE_PASSWORD_AUTH" = true ]; then
    sshpass -p "$SSH_PASSWORD" ssh "$SSH_USERNAME@$SSH_REFERENCE" "
        cd $REMOTE_DIR
        rm -f $ARCHIVE_NAME
    "
else
    ssh "$SSH_REFERENCE" "
        cd $REMOTE_DIR
        rm -f $ARCHIVE_NAME
    "
fi

echo "Done."
