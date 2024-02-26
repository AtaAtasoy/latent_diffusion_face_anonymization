#!/bin/bash

# Downloads the stable-diffusion-2-inpainting weights from HuggingFace, saves it at `models/stable-diffusion` named last.ckpt
mkdir -p models/stable-diffusion
wget https://huggingface.co/stabilityai/stable-diffusion-2-inpainting/resolve/main/512-inpainting-ema.ckpt?download=true -O models/stable-diffusion/last.ckpt

# Installs Nvidia Container Toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html
# It may require a reboot after installation
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit