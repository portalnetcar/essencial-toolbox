## Install WSL2

wsl --update

wsl --set-default-version 2

Create ".wslconfig" file on user path.

## Enable systemd by running the following command in the WSL terminal:

echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf

## Exit the WSL terminal, then restart WSL.

wsl --shutdown

wsl -d

sudo apt install make

## From this point, systemd is enabled and snaps should work properly. You can list the installed snaps with

sudo snap list

## Enabling CUDA

lspci | grep -i vga

lspci | grep VGA

nvidia-smi
sudo apt install nvidia-cuda-toolkit
nvcc --version
