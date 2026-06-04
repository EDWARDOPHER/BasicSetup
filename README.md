# Tony's Dotfiles

macOS-first, Linux-compatible dotfiles managed via symlinks.

## Quick Start

```bash
git clone git@github.com:EDWARDOPHER/BasicSetup.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What's Included

| Category | Config | Details |
|----------|--------|---------|
| Shell | Zsh + Oh My Zsh | robbyrussell theme, plugins: git, zsh-autosuggestions, syntax-highlighting, zsh-autocomplete, zfm |
| Terminal | tmux | Catppuccin Mocha theme, vim-style navigation, TPM plugins (resurrect, continuum, yank) |
| Fuzzy Find | fzf + fd + bat | Custom Catppuccin colors, utility functions (fe, fcd, fgb, fgc, fkill) |
| Editor | Neovim | Separate repo: [nvim_config](https://github.com/EDWARDOPHER/nvim_config) |
| Fonts | Consolas Regular | Installed automatically on macOS |

## Directory Structure

```
dotfiles/
├── install.sh              # One-command bootstrap
├── config/                 # Version-controlled dotfiles (symlinked to $HOME)
│   ├── .zshrc
│   ├── .tmux.conf
│   ├── .gitconfig
│   └── .tmux/scripts/
├── scripts/                # Dependency installers (idempotent, run independently)
│   ├── setup-brew.sh       # Homebrew + core packages
│   ├── setup-zsh.sh        # Oh My Zsh + plugins
│   └── setup-tmux.sh       # tmux + TPM
├── fonts/                  # Terminal fonts
└── README.md
```

## Machine-Specific Settings

The versioned configs are kept portable. Machine-specific settings go in unversioned `*.local` files:

- `~/.zshrc.local` — paths, toolchain versions, macOS-specific aliases
- `~/.gitconfig.local` — your email address
- `~/.tmux.conf.local` — tmux overrides (if needed)

These files are created as templates by `install.sh` on first run.

## Daily Workflow

After changing a config on your machine (files are symlinked, so edits go directly to the repo):

```bash
cd ~/dotfiles
git diff                    # Review changes
git add config/.zshrc
git commit -m "zsh: add docker alias"
git push
```

## Setup on a New Machine

```bash
git clone git@github.com:EDWARDOPHER/BasicSetup.git ~/dotfiles
cd ~/dotfiles
./install.sh
# Edit ~/.zshrc.local and ~/.gitconfig.local with machine-specific settings
```

For Neovim:
```bash
git clone git@github.com:EDWARDOPHER/nvim_config.git ~/.config/nvim
nvim +PlugInstall +qall
```

## Dependencies Auto-Installed

- **macOS**: Homebrew, yazi, fzf, fd, bat, tmux
- **Linux**: apt-get/dnf equivalents

Manual steps after install: start tmux and press `prefix + I` to install TPM plugins.
