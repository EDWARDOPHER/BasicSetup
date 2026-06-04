#!/bin/bash
# ==============================
# Dotfiles Bootstrap Script
# ==============================
# One-command setup for a new machine:
#   git clone git@github.com:EDWARDOPHER/BasicSetup.git ~/dotfiles
#   cd ~/dotfiles && ./install.sh
#
# What it does:
#   1. Detects OS (macOS/Linux)
#   2. Runs dependency installers
#   3. Symlinks config files from config/ to $HOME
#   4. Creates local override files for machine-specific settings
#   5. Installs fonts (macOS only)

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }

echo ""
echo "========================================"
echo "  Tony's Dotfiles Bootstrap"
echo "========================================"
echo ""

# ==============================
# OS Detection
# ==============================
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    print_info "Detected macOS"
elif [[ "$OS" == "Linux" ]]; then
    print_info "Detected Linux"
else
    print_error "Unsupported OS: $OS"
    exit 1
fi

# ==============================
# Run Setup Scripts
# ==============================

echo ""
echo "--- Installing dependencies ---"

# Make scripts executable
chmod +x "$DOTFILES/scripts/"*.sh 2>/dev/null || true

# Run setup scripts (each is idempotent)
"$DOTFILES/scripts/setup-brew.sh"
"$DOTFILES/scripts/setup-zsh.sh"
"$DOTFILES/scripts/setup-tmux.sh"

# ==============================
# Symlink Config Files
# ==============================

echo ""
echo "--- Setting up config symlinks ---"

# Create directories if they don't exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.tmux/scripts"

# Symlink function: backs up existing files before linking
symlink() {
    local src="$1"
    local dest="$2"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        local backup="${dest}.backup-$(date +%Y%m%d)"
        print_warning "Backing up existing $dest to $backup"
        mv "$dest" "$backup"
    fi

    if [[ -L "$dest" ]]; then
        # Already a symlink — update it
        ln -sf "$src" "$dest"
        print_info "Updated symlink: $dest"
    else
        ln -s "$src" "$dest"
        print_status "Linked: $dest"
    fi
}

# Link each config file
symlink "$DOTFILES/config/.zshrc"         "$HOME/.zshrc"
symlink "$DOTFILES/config/.tmux.conf"     "$HOME/.tmux.conf"
symlink "$DOTFILES/config/.gitconfig"     "$HOME/.gitconfig"

# Link tmux scripts
symlink "$DOTFILES/config/.tmux/scripts/tmux-sessionizer.sh" "$HOME/.tmux/scripts/tmux-sessionizer.sh"
symlink "$DOTFILES/config/.tmux/scripts/tmux-windowizer.sh"  "$HOME/.tmux/scripts/tmux-windowizer.sh"

# ==============================
# Local Override Files
# ==============================

echo ""
echo "--- Setting up local overrides ---"

if [[ ! -f "$HOME/.zshrc.local" ]]; then
    cat > "$HOME/.zshrc.local" << 'LOCALEOF'
# Machine-specific Zsh configuration
# This file is NOT version-controlled — customize freely.
#
# Add your paths, toolchain versions, and OS-specific settings here.
# This file is sourced at the end of .zshrc.

# Example:
# export GOPATH=$HOME/go
# export JAVA_HOME=/path/to/jdk
# alias vscode='open -a "Visual Studio Code"'
LOCALEOF
    print_status "Created ~/.zshrc.local (edit with your machine-specific settings)"
else
    print_warning "~/.zshrc.local already exists — skipping"
fi

if [[ ! -f "$HOME/.gitconfig.local" ]]; then
    cat > "$HOME/.gitconfig.local" << 'LOCALEOF'
[user]
    email = you@example.com
LOCALEOF
    print_status "Created ~/.gitconfig.local (set your email!)"
else
    print_warning "~/.gitconfig.local already exists — skipping"
fi

# ==============================
# Fonts
# ==============================

echo ""
echo "--- Installing fonts ---"

if [[ "$OS" == "Darwin" ]]; then
    if ls "$DOTFILES/fonts/"*.ttf &>/dev/null; then
        for font in "$DOTFILES/fonts/"*.ttf; do
            font_name=$(basename "$font")
            if [[ ! -f "$HOME/Library/Fonts/$font_name" ]]; then
                cp "$font" "$HOME/Library/Fonts/"
                print_status "Installed font: $font_name"
            else
                print_warning "Font already installed: $font_name"
            fi
        done
    fi
else
    print_info "Linux: install fonts manually from $DOTFILES/fonts/"
    print_info "  e.g. cp $DOTFILES/fonts/*.ttf ~/.local/share/fonts/"
fi

# ==============================
# Done
# ==============================

echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""
echo "What's installed:"
echo "  • Oh My Zsh + plugins (zsh-autosuggestions, syntax-highlighting, etc.)"
echo "  • fzf, fd, bat, yazi, tmux"
echo "  • Tmux Plugin Manager (TPM) + plugins"
echo "  • Config files symlinked from $DOTFILES/config/"
echo "  • Fonts installed (macOS)"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.zshrc.local — add your machine-specific paths"
echo "  2. Edit ~/.gitconfig.local — set your email address"
echo "  3. Start tmux and press prefix+I to install tmux plugins"
echo "  4. Restart your terminal or run: source ~/.zshrc"
echo ""
echo "For nvim setup, clone the separate nvim config repo:"
echo "  git clone git@github.com:EDWARDOPHER/nvim_config.git ~/.config/nvim"
echo ""
