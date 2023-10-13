#!/bin/bash

# Define the URL for the Helm installation script
helm_url="https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"

# Download the Helm installation script
curl -fsSL -o get_helm.sh "$helm_url"

# Modify the permissions of the downloaded script to make it executable
chmod 700 get_helm.sh

# Execute the Helm installation script
./get_helm.sh

# Optional: Remove the Helm installation script after installation
rm -f get_helm.sh
