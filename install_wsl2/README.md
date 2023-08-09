## Install WSL2

Install PowerShell from Windows App Store (Developer Tools) for maximum compability with informations provided.
(https://github.com/powershell/powershell)

wsl --update

<img align="center" alt="ubuntu2204" src="https://github.com/portalnetcar/essencial-toolbox/blob/main/install_wsl2/imgs/wsl_update_en.jpeg">

wsl --set-default-version 2

<img align="center" alt="ubuntu2204" src="https://github.com/portalnetcar/essencial-toolbox/blob/main/install_wsl2/imgs/wsl_setversion2_en.jpeg">

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

<img align="center" alt="ooppss..." src="https://github.com/portalnetcar/essencial-toolbox/blob/main/install_wsl2/imgs/wsl_ubuntu_systemd_en.jpeg">

## Exit the WSL terminal, then restart WSL.

exit

wsl --list -v

wsl --shutdown

wsl --list -v

<img align="center" alt="ubuntu2204" src="https://github.com/portalnetcar/essencial-toolbox/blob/main/install_wsl2/imgs/wsl_ubuntu_restart_en.jpeg">

wsl -d Ubuntu-22.04


  <img align="center" alt="ubuntu2204" src="https://github.com/portalnetcar/essencial-toolbox/blob/main/install_wsl2/imgs/ubuntu2204_install_en.jpeg">

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

Get Cuda driver - https://developer.nvidia.com/cuda-downloads - Maybe extra steps will be necessary, according to your machine configuration



nvcc --version

nvidia-smi

