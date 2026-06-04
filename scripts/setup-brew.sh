#!/bin/bash
# ==============================
# Homebrew Bootstrap Script
# ==============================
# Installs Homebrew and core formulae on macOS.
# On Linux, uses the system package manager.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

if [[ "$(uname -s)" == "Darwin" ]]; then
    # macOS: install Homebrew if missing
    if ! command -v brew &> /dev/null; then
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for current session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        print_status "Homebrew installed"
    else
        print_warning "Homebrew is already installed"
    fi

    # Core formulae
    print_status "Installing core formulae..."
    brew install yazi fd bat tmux fzf
    print_status "Core formulae installed"

else
    # Linux: use apt-get
    print_status "Linux detected, using apt-get..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y fd-find bat tmux fzf
        print_status "Core packages installed via apt-get"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y fd-find bat tmux fzf
        print_status "Core packages installed via dnf"
    else
        print_error "Unsupported Linux distribution. Please install packages manually."
    fi
fi
