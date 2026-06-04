#!/bin/bash
# ==============================
# Tmux + TPM Setup Script
# ==============================
# Installs tmux (if missing) and Tmux Plugin Manager.
# tmux config is managed by install.sh symlinks.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

# Install tmux if missing
if ! command -v tmux &> /dev/null; then
    print_status "Installing tmux..."
    if command -v brew &> /dev/null; then
        brew install tmux
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y tmux
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y tmux
    else
        print_error "Could not install tmux automatically. Please install it manually."
        exit 1
    fi
    print_status "tmux installed"
else
    print_warning "tmux is already installed"
fi

# Install TPM (Tmux Plugin Manager)
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    print_status "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    print_status "TPM installed"
else
    print_warning "TPM is already installed"
fi

echo ""
print_status "Tmux setup complete!"
echo ""
echo "To install tmux plugins, start tmux and press: prefix + I"
