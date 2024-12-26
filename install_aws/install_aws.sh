#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
AWS_CLI_ZIP="awscliv2.zip"
INSTALL_DIR="/usr/local/aws-cli"
BIN_DIR="/usr/local/bin"
AWS_DIR="$HOME/.aws"

# Move to Downloads directory
cd ~/Downloads

# Cleanup old downloads and extracted files
if [ -f "$AWS_CLI_ZIP" ]; then
    echo "Removing old AWS CLI zip file..."
    rm -f "$AWS_CLI_ZIP"
fi

if [ -d "aws" ]; then
    echo "Removing old AWS CLI extracted files..."
    rm -rf aws
fi

# Download the latest AWS CLI package
echo "Downloading AWS CLI..."
curl -s "$AWS_CLI_URL" -o "$AWS_CLI_ZIP"

# Unzip the package
echo "Extracting AWS CLI..."
unzip -q "$AWS_CLI_ZIP"

# Check if AWS CLI is already installed
if command -v aws &> /dev/null; then
    echo "AWS CLI is already installed. Updating..."
    sudo ./aws/install --bin-dir "$BIN_DIR" --install-dir "$INSTALL_DIR" --update
else
    echo "Installing AWS CLI..."
    sudo ./aws/install -i "$INSTALL_DIR" -b "$BIN_DIR"
fi

# Backup existing AWS configuration files
if [ -d "$AWS_DIR" ]; then
    echo "Backing up existing AWS configuration..."
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp -r "$AWS_DIR" "${AWS_DIR}_backup_$TIMESTAMP"
fi

# Create AWS config and credentials files if they don't exist
mkdir -p "$AWS_DIR"

CONFIG_FILE="$AWS_DIR/config"
CREDENTIALS_FILE="$AWS_DIR/credentials"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating default AWS CLI config..."
    echo -e "[default]\nregion = us-east-1\noutput = json" > "$CONFIG_FILE"
fi

if [ ! -f "$CREDENTIALS_FILE" ]; then
    echo "Creating placeholder AWS CLI credentials..."
    echo -e "[default]\naws_access_key_id = YOUR_ACCESS_KEY\naws_secret_access_key = YOUR_SECRET_KEY" > "$CREDENTIALS_FILE"
    echo "Please update '$CREDENTIALS_FILE' with your AWS access and secret keys."
fi

# Verify installation
echo "Verifying AWS CLI installation..."
aws --version

# Cleanup extracted files
echo "Cleaning up..."
rm -f "$AWS_CLI_ZIP"
rm -rf aws

echo "AWS CLI installation/update completed successfully!"
