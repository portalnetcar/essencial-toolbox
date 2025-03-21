#!/bin/bash

# Verifica se o VSCode já está instalado
if command -v code >/dev/null 2>&1; then
    echo "VSCode is already installed."
else
    echo "VSCode not found. Installing now..."
    
    # Instalação do Visual Studio Code
    if [ "$(uname)" == "Darwin" ]; then
        # macOS
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew not found. Please install Homebrew first."
            exit 1
        fi
        brew install --cask visual-studio-code
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Ubuntu/Debian
        sudo apt-get update
        sudo apt-get install -y wget gpg apt-transport-https
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt-get update
        sudo apt-get install -y code
    else
        echo "This script only supports macOS and Ubuntu/Debian Linux. Please visit https://code.visualstudio.com/download for instructions on how to install VSCode on other platforms."
        exit 1
    fi
fi

# Atualiza o Visual Studio Code
echo "Checking for updates..."

if [ "$(uname)" == "Darwin" ]; then
    brew update
    brew upgrade --cask visual-studio-code
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sudo apt-get update
    sudo apt-get install --only-upgrade code
fi

echo "Visual Studio Code is up to date."
