#!/bin/bash

while true; do
    # Get the battery percentage
    battery_level=$(pmset -g batt | grep -Eo '[0-9]+%' | cut -d% -f1)

    # Check if charger is connected
    charger_status=$(pmset -g batt | grep "AC Power")

    if [ -z "$charger_status" ] && [ "$battery_level" -le 15 ]; then
        # Play alert sound
        afplay /System/Library/Sounds/Ping.aiff
        
        # Show a notification
        osascript -e 'display notification "Battery Low! Plug in charger." with title "Low Battery Alert"'

        # Optional: Voice alert
        say "Battery Low! Please plug in the charger."
    fi

    # Wait for 300 seconds before checking again
    sleep 300
done
