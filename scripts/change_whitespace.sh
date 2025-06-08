#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <target_path> <replacement_string>"
    exit 1
fi

TARGET_PATH="$1"
REPLACEMENT="$2"

# Check if the target path exists
if [ ! -d "$TARGET_PATH" ]; then
    echo "Error: Target path '$TARGET_PATH' does not exist or is not a directory."
    exit 1
fi

# Find files with spaces in their names and rename them
find "$TARGET_PATH" -type f -name "* *" | while read -r file; do
    # Get the directory and filename
    dir=$(dirname "$file")
    filename=$(basename "$file")

    # Create the new filename by replacing spaces with the specified string
    new_filename="${filename// /$REPLACEMENT}"

    # Rename the file
    mv "$file" "$dir/$new_filename"

    echo "Renamed: $filename → $new_filename"
done

echo "Finished renaming files in $TARGET_PATH"
