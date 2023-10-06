#!/bin/bash

# Exit on any error
set -e

# Navigate to Downloads directory
cd ~/Downloads

# Download the AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the AWS CLI v2 package
unzip awscliv2.zip

# Install (or update) the AWS CLI
# Install (or update) the AWS CLI
if [ -d "/usr/local/aws-cli/v2/current" ]; then
    echo "Existing AWS CLI installation found. Updating..."
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
else
    sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
fi

# Pre-create local AWS configuration
mkdir -p ~/.aws
echo -e "[default]\nregion = us-west-2\noutput = json" > ~/.aws/config
echo -e "[default]\naws_access_key_id = YOUR_ACCESS_KEY\naws_secret_access_key = YOUR_SECRET_KEY" > ~/.aws/credentials

# Inform the user
echo "Please update ~/.aws/credentials with your AWS access and secret keys."

# Verify the installation
aws --version

echo "AWS CLI installation completed!"

