#!/bin/bash

# macOS Defaults Discovery Script
# This script helps you find your current macOS defaults modifications

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_section() {
  echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_info() {
  echo -e "${GREEN}$1${NC}"
}

print_warning() {
  echo -e "${YELLOW}$1${NC}"
}

print_section "Current macOS Defaults Discovery"

# Method 1: Export all current defaults to compare later
print_section "1. Exporting Current Defaults (for future comparison)"
print_info "Creating backup of current defaults..."
defaults read >~/current_defaults.plist
print_info "Current defaults exported to ~/current_defaults.plist"
print_warning "To find changes later, run this on a fresh Mac and compare with 'diff'"

# Method 2: Check common customizable domains
print_section "2. Common System Preferences"

echo "Dock settings:"
defaults read com.apple.dock | grep -E "(autohide|tilesize|orientation|minimize-to-application)" || echo "No custom dock settings found"

echo -e "\nFinder settings:"
defaults read com.apple.finder | grep -E "(ShowPathbar|ShowStatusBar|FXShowPosixPathInTitle|AppleShowAllExtensions)" || echo "No custom finder settings found"

echo -e "\nGlobal settings:"
defaults read NSGlobalDomain | grep -E "(KeyRepeat|InitialKeyRepeat|AppleShowAllExtensions|AppleInterfaceStyle)" || echo "No custom global settings found"

echo -e "\nScreenshot settings:"
defaults read com.apple.screencapture | grep -E "(location|type|disable-shadow)" || echo "No custom screenshot settings found"

echo -e "\nMission Control:"
defaults read com.apple.dock | grep -E "expose" || echo "No custom Mission Control settings found"

# Method 3: Check for modified plists in user preferences
print_section "3. Recently Modified Preference Files"
print_info "Recently modified preference files (last 30 days):"
find ~/Library/Preferences -name "*.plist" -mtime -30 -exec ls -la {} \; | head -20

# Method 4: Check specific apps you might have customized
print_section "4. Application-Specific Settings"

# Common apps that people customize
apps=("com.apple.Safari" "com.apple.Terminal" "com.apple.TextEdit" "com.apple.ActivityMonitor" "com.apple.Preview")

for app in "${apps[@]}"; do
  echo -e "\n${app}:"
  if defaults read "$app" &>/dev/null; then
    # Show non-default looking settings (this is a heuristic)
    defaults read "$app" | grep -v -E "^(\s*\{|\s*\}|\s*$)" | head -5 || echo "  No obvious customizations"
  else
    echo "  No preferences found"
  fi
done

# Method 5: System-wide modifications
print_section "5. System-wide Settings"

echo "Gatekeeper status:"
spctl --status

echo -e "\nSIP status:"
csrutil status

echo -e "\nCurrent shell:"
echo $SHELL

# Method 6: Check for third-party preference panes
print_section "6. Third-party Preference Panes"
if [ -d "/Library/PreferencePanes" ]; then
  echo "System-wide preference panes:"
  ls /Library/PreferencePanes/ 2>/dev/null || echo "None found"
fi

if [ -d "~/Library/PreferencePanes" ]; then
  echo -e "\nUser preference panes:"
  ls ~/Library/PreferencePanes/ 2>/dev/null || echo "None found"
fi

# Method 7: Generate a script template
print_section "7. Generating Template Script"

cat >~/macos_defaults_template.sh <<'EOF'
#!/bin/bash

# macOS Defaults Configuration
# Generated template - customize based on your discoveries above

# Dock
# defaults write com.apple.dock autohide -bool true
# defaults write com.apple.dock tilesize -int 48

# Finder
# defaults write com.apple.finder ShowPathbar -bool true
# defaults write com.apple.finder ShowStatusBar -bool true

# Global
# defaults write NSGlobalDomain KeyRepeat -int 2
# defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Screenshots
# defaults write com.apple.screencapture location ~/Screenshots

# Restart affected apps
# killall Dock
# killall Finder

EOF

print_info "Template script created at ~/macos_defaults_template.sh"

print_section "Instructions"
echo "1. Review the output above for your current settings"
echo "2. Edit ~/macos_defaults_template.sh with your preferred settings"
echo "3. Test the template on a fresh user account or VM"
echo "4. Add the working commands to your setup script"
echo ""
print_warning "Pro tip: Make changes in System Preferences, then run 'defaults read [domain]' to see what changed!"
