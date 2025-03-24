#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# === Configuration ===
TERRAFORM_BASE_URL="https://releases.hashicorp.com/terraform"
INSTALL_DIR="/usr/local/bin"
DOWNLOAD_DIR="$HOME/Downloads"
TERRAFORM_BIN="$INSTALL_DIR/terraform"
ARCH="amd64"
OS="linux"

# === Functions ===

# Get latest Terraform version
get_latest_version() {
    curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | grep -oP '"current_version":\s*"\K[0-9\.]+'
}

# === Script Execution ===

# Move to Downloads directory
cd "$DOWNLOAD_DIR"

# Get latest version dynamically
echo "Checking latest Terraform version..."
LATEST_VERSION=$(get_latest_version)
echo "Latest Terraform version: $LATEST_VERSION"

# Construct filename and URL
TERRAFORM_ZIP="terraform_${LATEST_VERSION}_${OS}_${ARCH}.zip"
TERRAFORM_URL="$TERRAFORM_BASE_URL/${LATEST_VERSION}/${TERRAFORM_ZIP}"

# Cleanup previous downloads
if [ -f "$TERRAFORM_ZIP" ]; then
    echo "Removing old Terraform zip file..."
    rm -f "$TERRAFORM_ZIP"
fi

if [ -f "terraform" ]; then
    echo "Removing old Terraform binary from Downloads..."
    rm -f terraform
fi

# Download Terraform
echo "Downloading Terraform $LATEST_VERSION..."
curl -s -O "$TERRAFORM_URL"

# Extract the binary
echo "Extracting Terraform..."
unzip -q "$TERRAFORM_ZIP"

# Backup existing Terraform binary if exists
if [ -f "$TERRAFORM_BIN" ]; then
    echo "Existing Terraform found. Backing up..."
    sudo mv "$TERRAFORM_BIN" "${TERRAFORM_BIN}_backup_$(date +%Y%m%d_%H%M%S)"
fi

# Move the new binary to install dir
echo "Installing Terraform to $INSTALL_DIR..."
sudo mv terraform "$INSTALL_DIR/"
sudo chmod +x "$TERRAFORM_BIN"

# Verify installation
echo "Verifying Terraform installation..."
terraform version

# Cleanup
echo "Cleaning up..."
rm -f "$TERRAFORM_ZIP"

echo "Terraform $LATEST_VERSION installation completed successfully!"
