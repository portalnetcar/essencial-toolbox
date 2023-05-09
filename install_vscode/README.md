## VSCode Check, Install and Update Script

This shell script checks if Visual Studio Code (VSCode) is installed on your system, and if not, it installs it. Additionally, the script checks for updates and installs them if necessary.

## Supported Platforms

- macOS
- Ubuntu/Debian Linux

## Prerequisites

- macOS: [Homebrew](https://brew.sh/) should be installed.
- Ubuntu/Debian Linux: User must have `sudo` permissions to install and update packages.

## Usage

1. Save the script as `vscode_check_install_update.sh` on your local machine.
2. Make the script executable by running the following command:

   ```bash
   chmod +x vscode_check_install_update.sh

## Or

1. You can run using curl:
```
curl -fsSL https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/main/vscode_check_install_update.sh | bash
```
2. This command downloads the script and pipes it directly to bash for execution. 

- Tested in:
1. Ubuntu 22.04 WLS2
2. Ubuntu 22.04

## Updates
- 20230508 - created and updated check.