#!/bin/bash

# Downloads the stable-diffusion-2-inpainting weights from HuggingFace, saves it at `models/stable-diffusion` named last.ckpt
mkdir -p models/stable-diffusion
wget https://huggingface.co/stabilityai/stable-diffusion-2-inpainting/resolve/main/512-inpainting-ema.ckpt?download=true -O models/stable-diffusion/last.ckpt