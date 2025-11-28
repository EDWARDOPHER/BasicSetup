#!/bin/bash

# ==============================
# Zsh Auto Setup Script
# ==============================
# This script installs and configures Zsh with Oh My Zsh and essential plugins

set -e

echo "🚀 Starting Zsh setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if Zsh is installed
if ! command -v zsh &> /dev/null; then
    print_error "Zsh is not installed. Please install Zsh first."
    exit 1
fi
print_status "Zsh is installed"

# Install Oh My Zsh if not already installed
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

# Install zfm (zsh file manager) if available
if [ ! -d "$ZSH_CUSTOM/plugins/zfm" ]; then
    print_status "Installing zfm..."
    git clone https://github.com/aoife/zfm.git "$ZSH_CUSTOM/plugins/zfm" 2>/dev/null || print_warning "zfm installation failed (may not be available)"
else
    print_warning "zfm is already installed"
fi

# Install fzf if not already installed
if ! command -v fzf &> /dev/null; then
    print_status "Installing fzf..."
    if command -v brew &> /dev/null; then
        brew install fzf
        # Install fzf key bindings and fuzzy completion
        $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
        print_status "fzf installed via Homebrew"
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y fzf
        print_status "fzf installed via apt-get"
    else
        # Manual installation
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
        print_status "fzf installed manually"
    fi
else
    print_warning "fzf is already installed"
fi

# Install fd (optional but recommended for fzf)
if ! command -v fd &> /dev/null; then
    print_status "Installing fd..."
    if command -v brew &> /dev/null; then
        brew install fd
        print_status "fd installed via Homebrew"
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y fd-find
        print_status "fd installed via apt-get"
    else
        print_warning "Could not install fd automatically"
    fi
else
    print_warning "fd is already installed"
fi

# Install bat (optional but recommended for fzf previews)
if ! command -v bat &> /dev/null; then
    print_status "Installing bat..."
    if command -v brew &> /dev/null; then
        brew install bat
        print_status "bat installed via Homebrew"
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y bat
        print_status "bat installed via apt-get"
    else
        print_warning "Could not install bat automatically"
    fi
else
    print_warning "bat is already installed"
fi

# Install tmux if not already installed
# if ! command -v tmux &> /dev/null; then
#    print_status "Installing tmux..."
#    if command -v brew &> /dev/null; then
#        brew install tmux
#        print_status "tmux installed via Homebrew"
#    elif command -v apt-get &> /dev/null; then
#        sudo apt-get install -y tmux
#        print_status "tmux installed via apt-get"
#    else
#        print_warning "Could not install tmux automatically"
#    fi
# else
#    print_warning "tmux is already installed"
# fi

# Create tmux sessionizer script directory
# mkdir -p "$HOME/.tmux/scripts"

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    print_status "Backing up existing .zshrc to .zshrc.backup"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Configure .zshrc with plugins
print_status "Configuring .zshrc..."
cat > "$HOME/.zshrc" << 'EOF'
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git zfm zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# User configuration

# ==============================
# Environment Variables
# ==============================

# Set default editor
export EDITOR=vim
export VISUAL=vim

# Color support for ls
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='CxfxcxdxbxegedabagGxGx'

# ==============================
# PATH Configuration
# ==============================
# Add your custom paths here
# Example:
# export PATH=$HOME/bin:$PATH
# export PATH=$PATH:/usr/local/bin

# ==============================
# tmux Configuration
# ==============================
# tmux aliases
# alias ta='tmux attach -t'
# alias tad='tmux attach -d -t'
# alias ts='tmux new-session -s'
# alias tl='tmux list-sessions'
# alias tksv='tmux kill-server'
# alias tkss='tmux kill-session -t'

# tmux sessionizer shortcut (Ctrl+f)
# Uncomment if you have tmux-sessionizer.sh
# bindkey -s ^f "~/.tmux/scripts/tmux-sessionizer.sh\n"

# ==============================
# fzf Configuration
# ==============================
# fzf initialization
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Homebrew fzf integration (macOS)
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Linux fzf integration
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# fzf default commands
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# fzf color scheme
export FZF_DEFAULT_OPTS='
  --height 40% --layout=reverse --border
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8
  --color=info:#cba6f7,prompt:#89b4fa,pointer:#f5e0dc
  --color=marker:#f5e0dc,spinner:#f5e0dc,header:#94e2d5
  --preview-window=right:60%:wrap
'

# fzf preview settings
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {} 2> /dev/null || cat {} 2> /dev/null || tree -C {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
"

# ==============================
# fzf Utility Functions
# ==============================

# fzf find and edit files
fe() {
  local files
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fzf find and change directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

# fzf git branch checkout
fgb() {
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fzf git commit browser
fgc() {
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fzf process kill
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# ==============================
# Custom Aliases
# ==============================
# Add your custom aliases here
# Example:
# alias ll='ls -lah'
# alias gs='git status'

EOF

print_status ".zshrc configured successfully"

# Set Zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
    print_status "Zsh is now your default shell (restart your terminal)"
else
    print_warning "Zsh is already your default shell"
fi

echo ""
print_status "✨ Zsh setup complete!"
echo ""
echo "Installed plugins:"
echo "  • git (Oh My Zsh built-in)"
echo "  • zsh-autosuggestions"
echo "  • zsh-syntax-highlighting"
echo "  • fast-syntax-highlighting"
echo "  • zsh-autocomplete"
echo "  • zfm (if available)"
echo ""
echo "Additional tools installed:"
echo "  • fzf (fuzzy finder)"
echo "  • fd (fast file finder)"
echo "  • bat (better cat)"
echo "  • (uninstalled)tmux (terminal multiplexer)"
echo ""
echo "Please restart your terminal or run: source ~/.zshrc"
