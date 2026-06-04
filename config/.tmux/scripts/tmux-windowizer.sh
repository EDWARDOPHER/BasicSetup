#!/usr/bin/env bash

# tmux window selector (using fzf)

if [[ -z $TMUX ]]; then
    echo "Please run this script inside a tmux session"
    exit 1
fi

# Get all windows and select with fzf
selected=$(tmux list-windows -F "#I: #W" | \
    fzf --height 40% --reverse --border --prompt="Select window: ")

if [[ -z $selected ]]; then
    exit 0
fi

# Extract window index
window_index=$(echo $selected | cut -d: -f1)

# Switch to selected window
tmux select-window -t $window_index
