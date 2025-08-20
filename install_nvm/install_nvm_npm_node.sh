#!/bin/bash

# =============================================================================
#
# Script: install_nvm_npm_node.sh
#
# Description: Installs nvm (Node Version Manager), the latest LTS version
#              of Node.js, and npm. It automatically fetches the latest nvm
#              version from the official GitHub repository.
#
# Compatibility: macOS & Linux
#
# Author: Gemini
# Date: August 20, 2025
#
# =============================================================================

# --- Configuration and Colors ---
# Use color codes for better output readability
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Helper Functions ---

# Function to print a formatted message
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Function to print a warning message
warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Function to print an error message and exit
error_exit() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

# --- Main Installation Logic ---

main() {
    info "Starting the installation of nvm, Node.js (LTS), and npm."

    # Step 1: Fetch the latest nvm version from GitHub
    info "Fetching the latest nvm version from GitHub..."
    # Use curl to get the latest release tag, handle redirects, and suppress progress meter
    # Fallback to a known good version if the API call fails
    LATEST_NVM_VERSION=$(curl -sL --fail "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$LATEST_NVM_VERSION" ]; then
        warn "Could not fetch the latest nvm version. Using a recent stable version as a fallback."
        LATEST_NVM_VERSION="v0.39.7" # A recent, known stable version
    else
        info "Latest nvm version found: ${LATEST_NVM_VERSION}"
    fi

    # Step 2: Download and run the official nvm installation script
    info "Downloading and executing the nvm installer..."
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_NVM_VERSION}/install.sh" | bash

    # The installer modifies shell profile files (.bashrc, .zshrc, .profile, etc.)
    # The output of the installer script itself will indicate which file was modified.

    # Step 3: Source nvm to make it available in the current shell session
    info "Sourcing nvm to make it available in the current session."
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        source "$NVM_DIR/nvm.sh"
    else
        error_exit "nvm script not found. Installation may have failed."
    fi

    # Step 4: Verify nvm installation
    if ! command -v nvm &> /dev/null; then
        error_exit "nvm command could not be found after installation and sourcing."
    else
        info "nvm has been installed successfully."
        info "nvm version: $(nvm --version)"
    fi

    # Step 5: Install the latest Long-Term Support (LTS) version of Node.js
    info "Installing the latest LTS version of Node.js... (This might take a few minutes)"
    nvm install --lts

    # The 'nvm install' command automatically runs 'nvm use' for the installed version.
    # We can set it as the default for new shells.
    nvm alias default lts/*
    info "Set the latest LTS version as the default for new shell sessions."

    # Step 6: Verify Node.js and npm installation
    info "Verifying installations..."
    echo -n "Node.js version: "
    node -v
    echo -n "npm version: "
    npm -v

    info "${GREEN}Installation complete!${NC}"
    info "Please close and reopen your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to start using nvm, node, and npm."
}

# --- Execute the Script ---
# The script starts execution here
main
