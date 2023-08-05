## Install WSL2

Install PowerShell from Windows App Store (Developer Tools) for maximum compability with informations provided.
(https://github.com/powershell/powershell)

wsl --update

wsl --set-default-version 2

Create ".wslconfig" file on user path, using the example file ".wslconfig" in this repo. (download)

wsl --list -v

wsl --shutdown

wsl -d


wsl --install Ubuntu-22.04

wsl -d Ubuntu-22.04


## Enable systemd by running the following command in the WSL terminal:

echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf

## Exit the WSL terminal, then restart WSL.


sudo apt install make

## From this point, systemd is enabled and snaps should work properly. You can list the installed snaps with

sudo snap list

## Enabling CUDA

lspci | grep -i vga

lspci | grep VGA

nvidia-smi
sudo apt install nvidia-cuda-toolkit
nvcc --version