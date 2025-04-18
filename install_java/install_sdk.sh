#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
SDKMAN_INSTALL_URL="https://get.sdkman.io"
SDKMAN_DIR="$HOME/.sdkman"

# Determine OS type
OS="$(uname -s)"

echo "Detected OS: $OS"

# Ensure prerequisites
case "$OS" in
    Linux*)
        # On Ubuntu, ensure curl is installed
        if ! command -v curl &> /dev/null; then
            echo "curl not found. Installing curl..."
            sudo apt-get update && sudo apt-get install -y curl
        fi
        ;;
    Darwin*)
        # On macOS, ensure curl is installed
        if ! command -v curl &> /dev/null; then
            echo "curl not found. Please install curl (e.g., via Homebrew) and re-run this script."
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Install or update SDKMAN
if command -v sdk &> /dev/null; then
    echo "SDKMAN already installed. Updating..."
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk selfupdate
else
    echo "Installing SDKMAN..."
    curl -s "$SDKMAN_INSTALL_URL" | bash
fi

# Initialize SDKMAN in current shell session
if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
    # shellcheck source=/dev/null
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    echo "SDKMAN initialization script sourced."
else
    echo "Initialization script not found. Please add the following to your shell profile and restart your session:"
    echo "  source '$SDKMAN_DIR/bin/sdkman-init.sh'"
    exit 1
fi

# Verify installation
echo "Verifying SDKMAN installation..."
sdk version

echo "SDKMAN installation/update completed successfully!"

