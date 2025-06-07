#!/bin/bash

{
    echo "--- DEBUG ENV ---"
    env
    echo "--- DEBUG PATH ---"
    echo "$PATH"
    echo "--- DEBUG XCLIP ---"
    command -v xclip
} >/tmp/wezterm_script_debug.log 2>&1

# --- Configuration ---
export DISPLAY="${DISPLAY:-:0}"
DEFAULT_PROMPT_TEMPLATE="""
---
Your name is QQB (Quick Question Bot) and you will assist me by answering my questions concisely and accurately in order to provide as much value as possible to a busy software engineer that is trying to get something done but just has a quick question on how to do something or how something works.

Because the engineer (me) is so busy, he will probably not even ask a proper question sometimes. You will also be responsible for figuring out what the engineer wants to know, depending on his prompt and the field(s) that he has a question on. It might be a question about key bindings, linux commands, libraries and dependencies on the language that he is working on, etc.

When appropriate (most of the time), your response will include an example or two in order to get the point across.

Each prompt is highly likely to have nothing to do with the previous prompt, but the field of interest will remain the same.

The field that the engineer has a question on is: 

{{CONTEXT}}

The language or framework that the engineer is working with (if applicable):
{{LANGUAGE}}

My first question is:
{{QUESTION}}
---
"""

PROMPT_TEMPLATE="${1:-$DEFAULT_PROMPT_TEMPLATE}"

# --- Improved Input Function ---
get_input() {
    local prompt_message="$1"
    local placeholder_text="$2"
    local variable_name="$3"
    local is_multiline="${4:-false}"

    if command -v gum &>/dev/null; then
        if [ "$is_multiline" = "true" ]; then
            # Use gum write for proper multiline input with Ctrl+D support
            gum style --border normal --margin "1" --padding "1" --border-foreground 212 "$prompt_message (Ctrl+D to finish):"
            input_content=$(gum write --placeholder "$placeholder_text")
            declare -g "$variable_name"="$input_content"
        else
            # Use gum input for single line
            input_content=$(gum input --placeholder "$placeholder_text" --prompt "$prompt_message : ")
            declare -g "$variable_name"="$input_content"
        fi
    else
        # Fallback to pure bash
        if [ "$is_multiline" = "true" ]; then
            echo "$prompt_message (Enter empty line to finish):"
            local input_content=""
            while IFS= read -r line; do
                [[ -z "$line" ]] && break
                input_content+="$line"$'\n'
            done
            declare -g "$variable_name"="${input_content%$'\n'}"
        else
            read -rp "$prompt_message ($placeholder_text): " -e "$variable_name"
        fi
    fi
}

# --- Main Script ---
placeholders=$(echo "$PROMPT_TEMPLATE" | grep -oP '\{\{\K[A-Z0-9_]+(?=\}\})' | sort -u)

[[ -z "$placeholders" ]] && {
    echo "No placeholders found"
    exit 1
}

declare -A values
echo "Please fill in the following details for your LLM prompt:"

for placeholder in $placeholders; do
    human_readable_placeholder=$(echo "$placeholder" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')
    is_multiline="false"
    [[ "$placeholder" == "CONTEXT" || "$placeholder" == "CODE" ]] && is_multiline="true"

    get_input "$human_readable_placeholder" "Enter $human_readable_placeholder" "$placeholder" "$is_multiline"
    values["$placeholder"]="${!placeholder}"
done

# --- Safe Template Substitution ---
final_prompt="$PROMPT_TEMPLATE"
for placeholder in $placeholders; do
    value="${values[$placeholder]}"
    # Escape for awk substitution
    escaped_value=$(awk -v s="$value" 'BEGIN { gsub(/[&\/\\]/, "\\\\&", s); print s }')
    final_prompt=$(awk -v p="$placeholder" -v v="$escaped_value" '{gsub("{{" p "}}", v)}1' <<<"$final_prompt")
done

copy_to_clipboard() {
    local content="$1"
    local attempts=3
    local delay=0.5
    local success=0

    for ((i = 1; i <= attempts; i++)); do
        # Try native WezTerm method first
        if [[ -n "$WEZTERM_PANE" ]] && command -v wezterm >/dev/null; then
            printf "\e]52;c;$(printf "%s" "$content" | base64)\a" && success=1

        # Try Wayland
        elif [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy >/dev/null; then
            echo -n "$content" | wl-copy && success=1

        # Try X11
        elif [[ -n "$DISPLAY" ]] && command -v xclip >/dev/null; then
            # Explicitly set XAUTHORITY if missing
            export XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"
            echo -n "$content" | xclip -selection clipboard -in 2>/dev/null && success=1

        # Try fallback methods
        elif command -v termux-clipboard-set >/dev/null; then
            echo -n "$content" | termux-clipboard-set && success=1
        fi

        # Check if successful
        if ((success)); then
            return 0
        fi

        sleep $delay
    done

    # Final fallback
    local fallback_file="/tmp/clipboard_fallback_$(date +%s).txt"
    echo "$content" >"$fallback_file"
    echo "ERROR: Could not copy to clipboard. Content saved to $fallback_file" >&2
    return 1
}

# --- Clipboard Handling ---
if ! copy_to_clipboard "$final_prompt"; then
    if command -v gum >/dev/null; then
        gum style --border thick --border-foreground 1 --padding "1 2" \
            "⚠ Failed to copy to clipboard!" \
            "Content saved to /tmp/clipboard_fallback_*.txt"
    else
        echo "⚠ Failed to copy to clipboard! Check /tmp/clipboard_fallback_*.txt" >&2
    fi
elif command -v gum >/dev/null; then
    gum style --foreground 212 "✔ Prompt copied to clipboard!"
    echo "$final_prompt" | gum format -t code
else
    echo "✔ Prompt copied to clipboard"
fi

read -p ok

i3-msg workspace 6
exit 0
