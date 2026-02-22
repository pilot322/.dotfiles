#!/bin/bash

PROMPT_DIR="$HOME/.prompts"
PROMPT_FILE="$PROMPT_DIR/.prompt.md"

# Create directory if it doesn't exist
mkdir -p "$PROMPT_DIR"

# If the main prompt file exists, rotate the backups
if [ -f "$PROMPT_FILE" ]; then
    # Delete .prompt_9.md if it exists
    rm -f "$PROMPT_DIR/.prompt_9.md"

    # Shift existing backups (8->9, 7->8, ..., 2->3)
    for i in 8 7 6 5 4 3 2; do
        if [ -f "$PROMPT_DIR/.prompt_${i}.md" ]; then
            mv "$PROMPT_DIR/.prompt_${i}.md" "$PROMPT_DIR/.prompt_$((i+1)).md"
        fi
    done

    # Move current prompt to .prompt_2.md
    mv "$PROMPT_FILE" "$PROMPT_DIR/.prompt_2.md"
fi

# Open neovim with the prompt file
nvim "$PROMPT_FILE"

# After nvim closes, copy the contents to clipboard using WezTerm's OSC 52
printf "\e]52;c;$(base64 < "$PROMPT_FILE")\a"

# Switch to i3 workspace 6
i3-msg workspace number 6
