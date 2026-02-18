# NVM, Node.js & npm Installer

This repository contains a simple, automated shell script to install **nvm** (Node Version Manager), the latest **LTS (Long-Term Support) version of Node.js**, and its corresponding **npm** (Node Package Manager).

The script is designed for a fresh setup on **macOS** and **Linux** systems.

## Features

-   **Automated:** Installs and configures everything with a single command.
-   **Up-to-Date:** Automatically fetches the latest version of nvm from GitHub.
-   **Best Practices:** Installs the recommended LTS version of Node.js, which is ideal for most development and production environments.
-   **Sets Default:** Configures the installed LTS version as the default for all new terminal sessions.
-   **Cross-Platform:** Compatible with both Linux and macOS.

## Quick Installation

To run the installer, open your terminal and execute the following command:

```bash
curl -fsSL [https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/develop/install_nvm/install_nvm_npm_node.sh](https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/develop/install_nvm/install_nvm_npm_node.sh) | bash
```

> **Note:** After the script finishes, you **must close and reopen your terminal** for the `nvm`, `node`, and `npm` commands to become available.

---

### ⚠️ Security Warning: Understanding `curl | bash`

Piping a script from the internet directly into `bash` is a convenient but potentially insecure practice. It executes the script without giving you a chance to review its contents first.

We trust that our script is safe, but as a good security practice, you should always inspect any script before running it on your system with root-level or user-level permissions.

You can **[review the script's code here](https://github.com/portalnetcar/essencial-toolbox/blob/develop/install_nvm/install_nvm_npm_node.sh)** before executing the command.

---

## What the Script Does

1.  **Fetches Latest NVM Version:** It checks the official nvm GitHub repository for the latest release tag.
2.  **Downloads and Installs NVM:** It runs the official `install.sh` script provided by the nvm team.
3.  **Updates Your Shell Profile:** It adds the necessary nvm configuration to your shell profile file (e.g., `.bashrc`, `.zshrc`).
4.  **Loads NVM:** It sources the nvm script so it can be used immediately in the current session.
5.  **Installs Node.js LTS:** It uses `nvm` to install the latest Long-Term Support version of Node.js.
6.  **Sets Default Node Version:** It configures the newly installed LTS version as the default for all future terminal sessions.
7.  **Verifies Installation:** It prints the versions of `nvm`, `node`, and `npm` to confirm that the installation was successful.

## Manual Installation (Safer Alternative)

If you prefer not to use the `curl | bash` method, you can follow these steps:

1.  **Clone the repository or download the script:**
    ```bash
    # Using git
    git clone [https://github.com/portalnetcar/essencial-toolbox.git](https://github.com/portalnetcar/essencial-toolbox.git)
    cd essencial-toolbox/install_nvm

    # Or using curl to just download the file
    curl -O [https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/develop/install_nvm/install_nvm_npm_node.sh](https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/develop/install_nvm/install_nvm_npm_node.sh)
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x install_nvm_npm_node.sh
    ```

3.  **Run the script:**
    ```bash
    ./install_nvm_npm_node.sh
    ```
