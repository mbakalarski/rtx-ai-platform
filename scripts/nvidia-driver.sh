#!/bin/bash
set -e

dmesg | grep -i nvidia
sudo apt update
sudo apt install ubuntu-drivers-common


nvidia-detector
# nvidia-driver-590


sudo apt install nvidia-driver-590-open # open !!!
sudo reboot

nvidia-smi
