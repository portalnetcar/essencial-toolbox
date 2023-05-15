#!/bin/bash

# Check if VSCode is installed
if command -v code >/dev/null 2>&1; then
    echo "VSCode is installed."
else
    echo "VSCode is not installed. Attempting to install..."
    curl -fsSL https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/main/vscode_check_install_update.sh | bash

    if command -v code >/dev/null 2>&1; then
        echo "VSCode has been successfully installed."
    else
        echo "Failed to install VSCode. Please try again."
        exit 1
    fi
fi

# List of extensions to check and install
declare -a extensions=(
    "golang.go"
    "bierner.markdown-mermaid"
    "hashicorp.terraform"
    # Add more extensions here, e.g., "ms-python.python"
)

# Check if each extension is installed
for extension in "${extensions[@]}"; do
    if code --list-extensions | grep -q "$extension"; then
        echo "Extension '$extension' is already installed."
    else
        echo "Extension '$extension' not found. Installing now..."
        code --install-extension "$extension"

        if [ $? -eq 0 ]; then
            echo "Extension '$extension' has been successfully installed."
        else
            echo "An error occurred while installing the extension '$extension'. Please try again."
            exit 1
        fi
    fi
done


echo "Installed extensions: "
code --list-extensions