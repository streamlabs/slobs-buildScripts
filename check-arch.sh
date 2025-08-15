#!/bin/bash
# Usage: ./check-arch.sh /path/to/search
# Example: ./check-arch.sh ~/projects/streamlabs/desktop/node_modules/obs-studio-node

SEARCH_DIR="${1:-.}"  # Default to current directory if no arg given

find "$SEARCH_DIR" -type f | while IFS= read -r file; do
    # Use "file" to get info
    info=$(file "$file")

    # Check if it's a binary (Mach-O executable or library)
    if [[ "$info" == *"Mach-O"* ]]; then
        # Check architecture
        if [[ "$info" != *"x86_64"* ]]; then
            echo "❌ Non-x86_64 binary: $file"
            echo "    $info"
        fi
    fi
done
