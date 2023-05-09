#!/bin/bash

# Check if VSCode is installed
if command -v code >/dev/null 2>&1; then
    echo "VSCode is already installed."
else
    echo "VSCode not found. Installing now..."
    
    # Install Visual Studio Code
    if [ "$(uname)" == "Darwin" ]; then
        # macOS
        brew install --cask visual-studio-code
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Ubuntu/Debian
	sudo apt-get install -y wget gpg
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg
	sudo apt install -y apt-transport-https
	sudo apt update
	sudo apt install -y code # or code-insiders 
    else
        echo "This script only supports macOS and Ubuntu/Debian Linux. Please visit https://code.visualstudio.com/download for instructions on how to install VSCode on other platforms."
        exit 1
    fi
fi

# Update Visual Studio Code
echo "Checking for updates..."

if [ "$(uname)" == "Darwin" ]; then
    # macOS
    brew update
    brew upgrade --cask visual-studio-code
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Ubuntu/Debian
    sudo apt-get update
    sudo apt-get upgrade code
fi

echo "Visual Studio Code is up to date."

