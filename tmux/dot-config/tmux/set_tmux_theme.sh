#!/bin/bash

# Function to check the macOS theme
get_macos_theme() {
    osascript -e 'tell application "System Events" to tell appearance preferences to return dark mode'
}

# Get the current theme
theme=$(get_macos_theme)

# Set the Catppuccin flavor based on the theme
if [ "$theme" = "true" ]; then
    catppuccin_flavour="mocha"
else
    catppuccin_flavour="latte"
fi

# Write the flavor to a temporary tmux config file
echo "set -g @catppuccin_flavour '$catppuccin_flavour'" > ~/.config/tmux/catppuccin_theme.conf
