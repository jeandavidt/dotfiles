#!/bin/bash

# Mac Setup Script
# This script automates the setup of a new Mac with dotfiles, Homebrew packages, and system configuration

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_status() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the dotfiles directory
if [ ! -f "Brewfile" ]; then
  print_error "Brewfile not found. Please run this script from your dotfiles directory."
  exit 1
fi

print_status "Starting Mac setup..."

# 1. Install Xcode Command Line Tools (required for Homebrew)
print_status "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  print_status "Installing Xcode Command Line Tools..."
  xcode-select --install
  print_warning "Please complete the Xcode Command Line Tools installation and rerun this script."
  exit 1
else
  print_success "Xcode Command Line Tools already installed"
fi

# 2. Install Homebrew
print_status "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
  print_status "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  print_success "Homebrew installed"
else
  print_success "Homebrew already installed"
fi

# 3. Install packages from Brewfile
print_status "Installing Homebrew packages..."
brew bundle install
print_success "Homebrew packages installed"

# 4. Set up dotfiles with stow
print_status "Setting up dotfiles..."

# Automatically stow all directories in the dotfiles repo
for dir in */; do
  # Remove trailing slash and skip hidden directories
  dir_name=${dir%/}
  if [[ ! "$dir_name" =~ ^\. ]]; then
    print_status "Stowing $dir_name..."
    stow "$dir_name"
    print_success "$dir_name configuration linked"
  fi
done

# 5. Set proper SSH permissions
if [ -d ~/.ssh ]; then
  print_status "Setting SSH permissions..."
  chmod 700 ~/.ssh
  if [ -f ~/.ssh/config ]; then
    chmod 600 ~/.ssh/config
  fi
  print_success "SSH permissions set"
fi

# 6. Generate SSH key if it doesn't exist
print_status "Checking for SSH key..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
  print_status "Generating SSH key..."
  read -p "Enter your email for SSH key: " email
  ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519

  print_success "SSH key generated"
  print_warning "Don't forget to add your public key to GitHub/GitLab/servers:"
  echo ""
  cat ~/.ssh/id_ed25519.pub
  echo ""
else
  print_success "SSH key already exists"
fi

# 7. Configure macOS defaults
print_status "Configuring macOS defaults..."

# Dock settings (based on your current setup)
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock tilesize -int 71
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock expose-group-apps -bool true

# Keyboard settings (your current fast settings)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Interface settings (your auto dark/light mode)
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Finder settings (your current preferences)
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Note: You don't seem to have _FXShowPosixPathInTitle enabled, so commenting out
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Terminal settings - handle theme setup manually

# Disable "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Show all filename extensions (if you want this - not currently set)
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

print_success "macOS defaults configured"

# 8. Restart affected applications
print_status "Restarting affected applications..."
killall Dock
killall Finder

# 9. Set up development environment
print_status "Setting up development environment..."

# Install Python packages globally with uv (if needed)
if command -v uv &>/dev/null; then
  print_status "Setting up Python environment with uv..."
  # Add any global Python packages you need here
  # uv tool install black
  # uv tool install ruff
  print_success "Python environment ready"
fi

# 10. Manual installation reminders
print_status "Manual installations needed:"
echo "  • Claude Desktop App (download from Anthropic)"
echo "  • Protégé (download from Stanford)"
echo "  • OpenVPN Connect (if not available via mas)"
echo "  • UGent Panno Text font (university-specific font)"
echo "  • Any other manual apps from your Applications folder"
echo ""

# 11. Final steps
print_success "Setup complete!"
print_warning "You may need to:"
echo "  1. Sign into Mac App Store to install mas apps"
echo "  2. Add SSH key to GitHub/GitLab/servers"
echo "  3. Sign into various applications"
echo "  4. Import any additional configuration files"
echo "  5. Restart your Mac to ensure all changes take effect"
echo ""
print_status "Happy coding! 🚀"
