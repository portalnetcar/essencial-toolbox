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

# Install or update SDKMAN and source it for the current session
if command -v sdk &> /dev/null; then
    echo "SDKMAN already installed. Updating..."
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk selfupdate
else
    echo "Installing SDKMAN..."
    curl -s "$SDKMAN_INSTALL_URL" | bash
    # Source SDKMAN scripts to make 'sdk' available right away
    if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
        # shellcheck source=/dev/null
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
    else
        echo "Error: Could not find SDKMAN init script at $SDKMAN_DIR/bin/sdkman-init.sh"
        exit 1
    fi
fi

# Verify installation
echo "Verifying SDKMAN availability..."
if ! command -v sdk &> /dev/null; then
    echo "Error: 'sdk' command not found. You may need to restart your shell or source the init script manually:"
    echo "  source '$SDKMAN_DIR/bin/sdkman-init.sh'"
    exit 1
fi
sdk version

# Install latest GraalVM
echo "Installing latest GraalVM..."
graalvm_id=$(sdk list java | awk '/grl\$/ {print $NF; exit}')
if sdk current java | grep -q "$graalvm_id"; then
    echo "GraalVM $graalvm_id already installed."
else
    sdk install java "$graalvm_id"
fi

# Install or upgrade Maven
echo "Installing/upgrading Maven..."
if sdk current maven | grep -q 'Using'; then
    sdk upgrade maven
else
    sdk install maven
fi

# Install or upgrade Gradle
echo "Installing/upgrading Gradle..."
if sdk current gradle | grep -q 'Using'; then
    sdk upgrade gradle
else
    sdk install gradle
fi

echo "SDKMAN candidate installations completed successfully!"
