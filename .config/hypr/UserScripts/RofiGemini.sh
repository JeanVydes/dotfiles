#!/bin/bash
# A script to query the Gemini API via a Python script and Rofi.
# This version creates the illusion of streaming by rapidly updating
# a rofi message box with new content.

# Path to your Rofi theme
rofi_theme="$HOME/.config/rofi/config-gemini.rasi"

# Path to the Python script
GEMINI_SCRIPT="$HOME/.config/hypr/scripts/rofi_gemini.py"

# Kill Rofi if already running before execution
pkill rofi

# A variable to hold the last full response to display in the prompt
message="Ask the AI..."

while true; do
    # Launch Rofi to get user input, displaying the last result or prompt
    prompt=$(rofi -i -dmenu -p "Gemini" -config "$rofi_theme" -mesg "$message")

    # If the user pressed Esc or closed Rofi, exit the script
    if [[ -z "$prompt" ]]; then
        exit 0
    fi

    # --- Streaming Logic ---
    # Variable to accumulate the streaming response
    full_response=""
    
    # Use Process Substitution to read the script's output.
    # This avoids creating a subshell, so variables modified in the loop persist.
    while read -d ' ' -r word; do
        # Append the new word to our full response
        full_response+="$word "

        # Kill any previous Rofi message box to prevent window stacking
        pkill -f "rofi -e" > /dev/null 2>&1
        
        # Display the updated message in a new Rofi box in the background
        # The '&' is crucial for the script to continue while rofi is open
        rofi -e "$full_response" -config "$rofi_theme" &
    done < <(echo "$prompt" | "$GEMINI_SCRIPT") # <--- This is the improved part

    # Clean up the last message box before looping
    pkill -f "rofi -e" > /dev/null 2>&1

    # Set the 'message' for the next Rofi prompt to be the final response
    # This now works correctly because we avoided the subshell.
    message="$full_response"
done