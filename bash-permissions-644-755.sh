set_permissions() {
    local target_directory=$1

    if [ -z "$target_directory" ]; then
        echo "Usage: set_permissions <directory>"
        return 1
    fi

    if [ ! -d "$target_directory" ]; then
        echo "Error: $target_directory is not a directory."
        return 1
    fi

    find "$target_directory" -type d -exec chmod 755 {} \;
    find "$target_directory" -type f -exec chmod 644 {} \;

    echo "Permissions set to 755 for directories and 644 for files in $target_directory"
}
