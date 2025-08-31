#!/bin/bash
# A simple script to search with DuckDuckGo using Rofi

rofi_theme="$HOME/.config/rofi/config-calc.rasi"

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

# main function
query=$(
    rofi -i -dmenu \
        -config "$rofi_theme" \
        -mesg "Search DuckDuckGo"
)

if [ -n "$query" ]; then
    xdg-open "https://duckduckgo.com/?q=$(printf "%s" "$query" | sed 's/ /+/g')" &
    exit
fi

exit