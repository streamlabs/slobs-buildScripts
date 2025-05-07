#!/bin/bash
cd ../desktop

# Script to recursively remove all .DS_Store files within a specified folder so that we can run codesign on Streamlabs-desktop.app. The codesign will
# die if it encounters a .DS_Store file. Ultimately, it would be nice to update electron-builder to deal with that and remove this script. But this type
# of issue will only occur on developer machine and havent figured out how to tell the codesign tools to ignore these hidden Apple Finder files.

# Function to remove .DS_Store files
remove_ds_store_files() {
    local target_directory="node_modules/obs-studio-node"

    if [ -d "$target_directory" ]; then
        echo "Searching for .DS_Store files in: $target_directory"
        
        # Find and delete all .DS_Store files
        find "$target_directory" -type f -name ".DS_Store" -print -exec rm -f {} \;

        echo "All .DS_Store files removed successfully from $target_directory"
    else
        echo "Error: Directory '$target_directory' does not exist."
        exit 1
    fi
}

remove_ds_store_files