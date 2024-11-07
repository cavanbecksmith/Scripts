#!/bin/bash

# Define a function for scp with upload/download capability using a key file
transfer_with_key() {
    local keyfile="$1"         # Path to the SSH key file
    local direction="$2"       # Direction of transfer: "upload" or "download"
    local source="$3"          # Source path (local or remote depending on direction)
    local destination="$4"     # Destination path (local or remote depending on direction)
    local user="$5"            # Username for remote server (required for remote paths)
    local ip="$6"              # IP address of remote server (required for remote paths)

    # Determine the source and destination paths based on direction
    if [[ "$direction" == "upload" ]]; then
        # Upload from local to remote
        scp -i "$keyfile" \
            -o HostKeyAlgorithms=+ssh-rsa \
            -o PubkeyAcceptedAlgorithms=+ssh-rsa \
            -r "$source" "$user@$ip:$destination"
    elif [[ "$direction" == "download" ]]; then
        # Download from remote to local
        scp -i "$keyfile" \
            -o HostKeyAlgorithms=+ssh-rsa \
            -o PubkeyAcceptedAlgorithms=+ssh-rsa \
            -r "$user@$ip:$source" "$destination"
    else
        echo "Invalid direction specified. Use 'upload' or 'download'."
    fi
}

# Usage examples:
# Upload example:
# transfer_with_key "/path/to/keyfile" "upload" "/c/Users/user/test" "/remote/test" "user" "ip"

# Download example:
# transfer_with_key "/path/to/keyfile" "download" "/remote/test" "/c/Users/user/test" "user" "ip"