#!/bin/bash

# Check if Python 3.10 or later is installed
python_version=$(python3 -c 'import sys; print("{}.{}".format(sys.version_info.major, sys.version_info.minor))' 2>/dev/null)
if [ $? -eq 0 ] && [ "${python_version%.*}" -ge 3 ] && [ "${python_version#*.}" -ge 10 ]; then
    echo "Python 3.10 or later is already installed."
    python3 --version
else
    echo "Python 3.10 or later is not installed. Installing from source now..."

    # Install required build dependencies
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                sudo apt-get update
                sudo apt-get install -y build-essential wget libssl-dev libffi-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libsqlite3-dev libbz2-dev
                ;;
            centos|rhel|fedora)
                sudo yum groupinstall -y "Development Tools"
                sudo yum install -y wget openssl-devel bzip2-devel libffi-devel zlib-devel ncurses-devel gdbm-devel nss-devel readline-devel sqlite-devel xz-devel
                ;;
            *)
                echo "Unsupported distribution. Please install Python 3.10 or later manually."
                exit 1
                ;;
        esac
    else
        echo "Unable to detect distribution. Please install Python 3.10 or later manually."
        exit 1
    fi

    # Download and build Python from source
    PYTHON_LATEST_URL="https://www.python.org/ftp/python/$(wget -q -O - https://www.python.org/downloads/ | grep -oE 'Python 3\.[0-9]+\.[0-9]+' | sort -V -r | head -n 1)/Python-$(wget -q -O - https://www.python.org/downloads/ | grep -oE 'Python 3\.[0-9]+\.[0-9]+' | sort -V -r | head -n 1).tgz"
    wget -O python-latest.tgz "$PYTHON_LATEST_URL"
    tar xzf python-latest.tgz
    cd "$(find . -maxdepth 1 -type d -name 'Python-*' | head -n 1)" || exit
    ./configure --enable-optimizations --with-ensurepip=install
    make -j "$(nproc)"
    sudo make altinstall

    # Cleanup
    cd .. || exit
    rm -rf "$(find . -maxdepth 1 -type d -name 'Python-*' | head -n 1)"
    rm python-latest.tgz

    echo "Python 3.10 or later installation complete."
    python3.10 --version
fi
