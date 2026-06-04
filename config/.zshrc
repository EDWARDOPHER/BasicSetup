# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git zfm zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# User configuration

# ==============================
# Environment Variables
# ==============================

# Color support for ls
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='CxfxcxdxbxegedabagGxGx'

# ==============================
# tmux Configuration
# ==============================

# Auto-start tmux (comment out if you don't want this)
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session
fi

# tmux shortcuts
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# tmux sessionizer shortcut (Ctrl+f)
bindkey -s ^f "~/.tmux/scripts/tmux-sessionizer.sh\n"

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

# fzf default commands (use fd if available, fallback to rg)
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd . --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd . --type d --hidden --follow --exclude .git'
elif command -v rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg . --files --hidden --follow --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# fzf color scheme (Catppuccin Mocha)
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
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
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
# Neovim Configuration
# ==============================

export EDITOR=nvim
export VISUAL=nvim

alias vi='nvim'
alias vim='nvim'
alias v='nvim'

# zsh auto complete — show all candidates without confirmation prompt
export LISTMAX=1000

# ==============================
# Machine-specific overrides
# ==============================
# Put your local paths, toolchain versions, and macOS-specific settings in:
#   ~/.zshrc.local
# This file is NOT version-controlled.

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
