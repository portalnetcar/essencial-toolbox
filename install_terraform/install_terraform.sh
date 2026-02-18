#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# === Configuration ===
INSTALL_DIR="/usr/local/bin"
DOWNLOAD_DIR="$HOME/Downloads"
BACKUP_DIR="$HOME/.terraform-backups"
TERRAFORM_BIN="$INSTALL_DIR/terraform"
TERRAFORM_BASE_URL="https://releases.hashicorp.com/terraform"

# Detect architecture and OS
ARCH=$(uname -m)
OS=$(uname | tr '[:upper:]' '[:lower:]')

case "$ARCH" in
    x86_64) PLATFORM_ARCH="amd64" ;;
    arm64|aarch64) PLATFORM_ARCH="arm64" ;;
    *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

case "$OS" in
    linux|darwin) PLATFORM_OS="$OS" ;;
    *) echo "❌ Unsupported OS: $OS"; exit 1 ;;
esac

# === Functions ===

get_latest_version() {
    curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | awk -F'"' '{for(i=1; i<=NF; i++) {if ($i == "current_version") {print $(i+2); exit}}}'
}


# === Begin Installation ===

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Get latest version dynamically
echo "🔍 Checking latest Terraform version..."
LATEST_VERSION=$(get_latest_version)
echo "📦 Latest version: $LATEST_VERSION"

TERRAFORM_ZIP="terraform_${LATEST_VERSION}_${PLATFORM_OS}_${PLATFORM_ARCH}.zip"
TERRAFORM_URL="${TERRAFORM_BASE_URL}/${LATEST_VERSION}/${TERRAFORM_ZIP}"

# Cleanup old files
rm -f terraform "$TERRAFORM_ZIP"

# Download Terraform
echo "⬇️ Downloading Terraform for $PLATFORM_OS/$PLATFORM_ARCH..."
curl -s -O "$TERRAFORM_URL"

# Extract the binary
echo "📂 Extracting..."
unzip -q "$TERRAFORM_ZIP"

# Backup existing version
if [ -f "$TERRAFORM_BIN" ]; then
    echo "🔁 Backing up current Terraform binary..."
    mkdir -p "$BACKUP_DIR"
    sudo mv "$TERRAFORM_BIN" "$BACKUP_DIR/terraform_backup_$(date +%Y%m%d_%H%M%S)"
fi

# Install new binary
echo "🚀 Installing Terraform to $INSTALL_DIR..."
sudo mv terraform "$TERRAFORM_BIN"
sudo chmod +x "$TERRAFORM_BIN"

# Verify installation
echo "✅ Verifying installation..."
terraform version

# Final cleanup
echo "🧹 Cleaning up..."
rm -f "$TERRAFORM_ZIP"

echo "🎉 Terraform $LATEST_VERSION installed successfully!"
