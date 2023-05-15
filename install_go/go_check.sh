#!/bin/bash

# Get the latest version of Go
GO_LATEST=$(curl -sS https://go.dev/dl/ | grep -oP 'go[0-9]+\.[0-9]+(\.[0-9]+)?\.linux-amd64\.tar\.gz' | awk 'NR==1')


if [ -z "$GO_LATEST" ]; then
    echo "Failed to find the latest version of Go. Please try again."
    exit 1
fi

# Download the latest version of Go
echo "Downloading the latest version of Go: $GO_LATEST"
curl -LO "https://golang.org/dl/$GO_LATEST"

if [ ! -f "$GO_LATEST" ]; then
    echo "Failed to download Go. Please try again."
    exit 1
fi

# Remove any existing Go installation
if [ -d "/usr/local/go" ]; then
    sudo rm -rf /usr/local/go
fi

# Install Go
echo "Installing Go..."
sudo tar -C /usr/local -xzf "$GO_LATEST"

# Add Go binary path to the shell profile file
SHELL_PROFILE="$HOME/.bashrc"  # For bash users, change to .zshrc for zsh users or the appropriate shell profile file
echo 'export PATH="$PATH:/usr/local/go/bin"' >> "$SHELL_PROFILE"
source "$SHELL_PROFILE"

# Clean up
rm "$GO_LATEST"

# Verify installation
go version
if [ $? -eq 0 ]; then
    echo "Go has been successfully installed."
else
    echo "Go installation failed. Please try again."
    exit 1
fi