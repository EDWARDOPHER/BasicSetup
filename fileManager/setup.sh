#!/bin/bash

# yazi file manager installation
#
# homebrew
#

# 检查是否安装了 Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew 未安装，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 将 brew 添加到 PATH（适配 macOS Intel 和 Apple Silicon）
    if [[ -d "/opt/homebrew/bin" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew 已安装"
fi

# 更新 Homebrew
echo "Homebrew updating...."
brew update


# 安装 yazi
echo "Installing yazi by homebrew..."
brew install yazi
echo "\n*** yazi has beeb installed SUCCESS***"
# 你可以选择 --HEAD 安装最新版: brew install yazi --HEAD
