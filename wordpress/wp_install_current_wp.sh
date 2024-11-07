#!/bin/bash

# Define the target directory
target_dir="wordpress/app"
temp_dir="wp_temp"

# Check if the target directory exists
if [ ! -d "$target_dir" ]; then
    # Create the directory if it doesn't exist
    mkdir -p "$target_dir"
fi

# Download the latest version of WordPress using curl
echo "Downloading the latest version of WordPress..."
curl -O https://wordpress.org/latest.tar.gz

# Check if the download was successful
if [ ! -f "latest.tar.gz" ]; then
    echo "Error: Failed to download WordPress."
    exit 1
fi

# Extract the downloaded file into a temporary directory
echo "Extracting WordPress..."
mkdir -p "$temp_dir"
tar -xzf latest.tar.gz -C "$temp_dir" --strip-components=1

# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract WordPress."
    exit 1
fi

# Move the WordPress files to the target directory without overwriting existing files
echo "Installing WordPress in $target_dir..."
cp -r "$temp_dir"/* "$target_dir"

# Clean up
echo "Cleaning up..."
rm -rf "$temp_dir" latest.tar.gz

echo "WordPress installation completed in $target_dir."