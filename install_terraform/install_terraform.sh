#!/bin/bash

# Exit on any error
set -e

# Download Terraform
curl -o ~/Downloads/terraform.zip https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip

# Unzip Terraform binary
unzip ~/Downloads/terraform.zip -d ~/Downloads/

# Move Terraform binary to the desired location
sudo mv ~/Downloads/terraform /usr/local/bin/

# Verify the installation
terraform --version

echo "Terraform installation completed!"

