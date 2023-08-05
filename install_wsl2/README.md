## Install WSL2

Install PowerShell from Windows App Store (Developer Tools) for maximum compability with informations provided.
(https://github.com/powershell/powershell)

wsl --update

wsl --set-default-version 2

Create ".wslconfig" file on user path, using the example file ".wslconfig" in this repo. (download)

wsl --list -v

wsl --shutdown


wsl --install Ubuntu-22.04

exit 

wsl --list -v

wsl -d Ubuntu-22.04

cat /etc/issue


## Enable systemd by running the following command in the WSL terminal:

echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf

cat /etc/wsl.conf


## Exit the WSL terminal, then restart WSL.

exit

wsl --list -v

wsl --shutdown

wsl --list -v

wsl -d Ubuntu-22.04

sudo apt update

sudo apt upgrade 

sudo apt install make

## From this point, systemd is enabled and snaps should work properly. You can list the installed snaps with

sudo snap list

## Enabling CUDA

lspci | grep -i vga

lspci | grep VGA

nvidia-smi

sudo apt install nvidia-cuda-toolkit

Get Cuda driver - https://developer.nvidia.com/cuda-downloads

nvcc --version

nvidia-smi

