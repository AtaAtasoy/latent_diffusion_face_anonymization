FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

RUN apt-get update && apt-get install -y wget git build-essential python3 python3-pip ffmpeg libsm6 libxext6 cuda-compat-11-8
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /opt/gui
WORKDIR /opt/gui
RUN git checkout tags/v1.3.2
RUN python3 -m pip install -r requirements_versions.txt
RUN python3 -m pip install open_clip_torch
RUN git clone https://github.com/Stability-AI/stablediffusion repositories/stable-diffusion-stability-ai
RUN git clone https://github.com/crowsonkb/k-diffusion.git repositories/k-diffusion
RUN git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers
RUN git clone https://github.com/sczhou/CodeFormer repositories/CodeFormer

# Install CodeFormer
WORKDIR /opt/gui/repositories/CodeFormer
RUN python3 -m pip install basicsr
# Fix basicsr get_device error
RUN echo "\nimport torch\ndef get_device():\n    if torch.cuda.is_available():\n        return torch.device('cuda')\n    else:\n        return torch.device('cpu')\n\ndef gpu_is_available():\n        return torch.cuda.is_available()\n" >> /usr/local/lib/python3.10/dist-packages/basicsr/utils/misc.py
RUN python3 -m pip install -r requirements.txt
RUN python3 basicsr/setup.py develop

# Install taming-transformers
WORKDIR /opt/gui/repositories/taming-transformers
RUN python3 setup.py build develop

# install k-diffusion
WORKDIR /opt/gui/repositories/k-diffusion
RUN python3 -m pip install -e .
WORKDIR /opt/gui

# Install xformers
RUN python3 -m pip install ninja
# Setting a large list to support multiple GPU architectures
ENV TORCH_CUDA_ARCH_LIST="6.0;6.1;6.2;7.0;7.2;7.5;8.0;8.6"
RUN python3 -m pip install -U xformers --index-url https://download.pytorch.org/whl/cu118

# torchvision nms bugfix
RUN python3 -m pip uninstall -y torchvision
RUN git clone https://github.com/pytorch/vision.git
WORKDIR /opt/gui/vision
RUN python3 setup.py build
RUN python3 setup.py install

COPY . /tool
WORKDIR /tool
RUN python3 -m pip install -r requirements.txt
RUN python3 -m pip install httpx==0.24.1
RUN python3 setup.py build
RUN python3 setup.py develop

RUN sed -i 's/from torchvision.transforms.functional_tensor import rgb_to_grayscale/from torchvision.transforms.functional import rgb_to_grayscale/' /usr/local/lib/python3.10/dist-packages/basicsr/data/degradations.py

WORKDIR /opt/gui
ENTRYPOINT python3 webui.py --listen --api --xformers