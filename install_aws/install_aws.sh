#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# === Configuration ===
INSTALL_DIR="/usr/local/aws-cli"
BIN_DIR="/usr/local/bin"
DOWNLOAD_DIR="$HOME/Downloads"
BACKUP_DIR="$HOME/.aws-cli-backups"
AWS_ZIP="awscliv2.zip"
AWS_DIR="$HOME/.aws"

# Detect system architecture and OS
ARCH=$(uname -m)
OS=$(uname | tr '[:upper:]' '[:lower:]')

case "$ARCH" in
    x86_64) PLATFORM="x86_64" ;;
    arm64|aarch64) PLATFORM="aarch64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

case "$OS" in
    linux) AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-${PLATFORM}.zip" ;;
    darwin) AWS_CLI_URL="https://awscli.amazonaws.com/AWSCLIV2.pkg" ;;
    *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

# === Begin Installation ===
echo "Installing AWS CLI v2 for $OS on $ARCH..."

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Cleanup old files
rm -f "$AWS_ZIP"
rm -rf aws

# Download AWS CLI
if [ "$OS" = "linux" ]; then
    echo "Downloading AWS CLI..."
    curl -s "$AWS_CLI_URL" -o "$AWS_ZIP"

    echo "Extracting AWS CLI..."
    unzip -q "$AWS_ZIP"

    # Backup existing installation
    if command -v aws &> /dev/null; then
        echo "Backing up existing AWS CLI..."
        VERSION=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        mkdir -p "$BACKUP_DIR"
        sudo cp -r "$INSTALL_DIR" "$BACKUP_DIR/aws-cli-v${VERSION}_$TIMESTAMP"
    fi

    # Install or update
    if [ -d "$INSTALL_DIR/v2/current" ]; then
        echo "Updating AWS CLI..."
        sudo ./aws/install --bin-dir "$BIN_DIR" --install-dir "$INSTALL_DIR" --update
    else
        echo "Installing AWS CLI..."
        sudo ./aws/install -i "$INSTALL_DIR" -b "$BIN_DIR"
    fi

    # Cleanup
    echo "Cleaning up..."
    rm -f "$AWS_ZIP"
    rm -rf aws

elif [ "$OS" = "darwin" ]; then
    echo "Downloading AWS CLI for macOS..."
    curl -s "$AWS_CLI_URL" -o AWSCLIV2.pkg

    echo "Installing AWS CLI (you may be prompted for your password)..."
    sudo installer -pkg AWSCLIV2.pkg -target /

    echo "Cleaning up..."
    rm -f AWSCLIV2.pkg
fi

# Verify installation
echo "Verifying installation..."
aws --version

# Ensure config/credentials folders exist
mkdir -p "$AWS_DIR"
CONFIG_FILE="$AWS_DIR/config"
CREDENTIALS_FILE="$AWS_DIR/credentials"

# Create minimal config files if not exist
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating default config..."
    echo -e "[default]\nregion = us-east-1\noutput = json" > "$CONFIG_FILE"
fi

if [ ! -f "$CREDENTIALS_FILE" ]; then
    echo "Creating placeholder credentials..."
    echo -e "[default]\naws_access_key_id = YOUR_ACCESS_KEY\naws_secret_access_key = YOUR_SECRET_KEY" > "$CREDENTIALS_FILE"
    echo "⚠️  Please update your credentials at: $CREDENTIALS_FILE"
fi

echo "✅ AWS CLI installation/update completed successfully!"
