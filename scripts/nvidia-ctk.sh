#!/bin/bash
set -e

########################################################################
echo NVIDIA Container Toolkit / Install
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
   ca-certificates \
   curl \
   gnupg2

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update


apt-cache madison nvidia-container-toolkit | head -1
# nvidia-container-toolkit |   1.19.0-1 | https://nvidia.github.io/libnvidia-container/stable/deb/amd64  Packages

export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.19.0-1
sudo apt-get install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}


########################################################################
echo NVIDIA Container Toolkit / Configuring containerd
# single node with --set-as-default

sudo nvidia-ctk runtime configure --runtime=containerd --set-as-default

find /etc/containerd/ -type f -exec grep default_runtime_name {} \;

#      default_runtime_name = "nvidia"
#      default_runtime_name = "nvidia"

sudo systemctl restart containerd.service
sudo systemctl restart kubelet.service
