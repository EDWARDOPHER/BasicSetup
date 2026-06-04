#!/bin/bash
# ==============================
# Zsh + Oh My Zsh Setup Script
# ==============================
# Installs Oh My Zsh and essential plugins.
# Does NOT generate .zshrc — config is managed by install.sh symlinks.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

# Check if Zsh is installed
if ! command -v zsh &> /dev/null; then
    print_error "Zsh is not installed. Please install Zsh first."
    exit 1
fi
print_status "Zsh is installed"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_status "Oh My Zsh installed"
else
    print_warning "Oh My Zsh is already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_status "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_status "zsh-autosuggestions installed"
else
    print_warning "zsh-autosuggestions is already installed"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_status "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_status "zsh-syntax-highlighting installed"
else
    print_warning "zsh-syntax-highlighting is already installed"
fi

# Install fast-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
    print_status "Installing fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
    print_status "fast-syntax-highlighting installed"
else
    print_warning "fast-syntax-highlighting is already installed"
fi

# Install zsh-autocomplete
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
    print_status "Installing zsh-autocomplete..."
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"
    print_status "zsh-autocomplete installed"
else
    print_warning "zsh-autocomplete is already installed"
fi

# Install zfm (zsh file manager)
if [ ! -d "$ZSH_CUSTOM/plugins/zfm" ]; then
    print_status "Installing zfm..."
    git clone https://github.com/aoife/zfm.git "$ZSH_CUSTOM/plugins/zfm" 2>/dev/null || print_warning "zfm installation failed (may not be available)"
else
    print_warning "zfm is already installed"
fi

# Set Zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
    print_status "Zsh is now your default shell (restart your terminal)"
else
    print_warning "Zsh is already your default shell"
fi

echo ""
print_status "Zsh setup complete!"
echo ""
echo "Plugins installed: git, zsh-autosuggestions, zsh-syntax-highlighting,"
echo "                      fast-syntax-highlighting, zsh-autocomplete, zfm"
