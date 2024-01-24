FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

RUN apt-get update && apt-get install -y wget git build-essential python3 python3-pip ffmpeg libsm6 libxext6
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /opt/gui
WORKDIR /opt/gui
RUN git checkout tags/v1.7.0
RUN python3 -m pip install -U xformers --index-url https://download.pytorch.org/whl/cu118
RUN python3 -m pip install -r requirements_versions.txt
RUN python3 -m pip install open_clip_torch
RUN python3 -m pip install --pre git+https://github.com/crowsonkb/k-diffusion.git --prefer-binary --extra-index-url https://download.pytorch.org/whl/nightly/cu118
RUN git clone https://github.com/Stability-AI/generative-models.git /repositories/generative-models

COPY . /tool
WORKDIR /tool
RUN python3 -m pip install -r requirements.txt
RUN python3 setup.py install

WORKDIR /opt/gui
ENTRYPOINT python3 webui.py --listen --api
