[![Static Badge](https://img.shields.io/badge/Paper-CVPRW23-1c75b8?style=plastic)](https://openaccess.thecvf.com/content/CVPR2023W/E2EAD/papers/Klemp_LDFA_Latent_Diffusion_Face_Anonymization_for_Self-Driving_Applications_CVPRW_2023_paper.pdf)

# Latent Diffusion Face Anonymisation LDFA
This repository contains the code for the paper LDFA: Latent Diffusion Face Anonymization for Self-driving Applications.

## Personal Contributions:
- Modifications to Dockerfile for integrating [xformers](https://github.com/facebookresearch/xformers), [k-diffusion](https://github.com/crowsonkb/k-diffusion.git), [taming-transformers](https://github.com/CompVis/taming-transformers.git) and [CodeFormer](https://github.com/sczhou/CodeFormer) to [Automatic1111](https://github.com/AUTOMATIC1111/stable-diffusion-webui).
- Additional bash scripts to setup the environment and running detection & anonymization.

## Requirements
- Docker Compose V2. See [Diff between V1 and V2](https://docs.docker.com/compose/migrate/#what-are-the-functional-differences-between-compose-v1-and-compose-v2). [Install](https://docs.docker.com/compose/install/linux/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)

## Setup
```shell
bash setup_requirements.sh # Downloads stable diffusion weights & nvidia-container-toolkit
bash setup_compose_env.sh # Sets the container variables
```

## Usage
After you run ```setup_requirements.sh``` and ```setup_compose_env.sh```, you can start the docker instances with `docker compose up`.
The script will look for all images with the given extension in the provided root folder. Make sure you are using `bash` to execute the scripts.
Once the docker container is running you can generate masks with:
```shell
bash generate_masks.sh
```

and anonymize the detected faces using:
```shell
bash anonymize.sh
```

## Structure
### Dockerfile
The dockerfile is used to start container which runs the [Automatic1111](https://github.com/AUTOMATIC1111/stable-diffusion-webui) web UI for stable diffusion. LDFA uses the API to conveniently use a stable diffusion model for the anonymization of human faces.

### Scripts

- `detect_faces.py` - This script uses [RetinaFace](https://github.com/serengil/retinaface) to detect faces on a given dataset.  
- `ldfa_face_anon.py` - This script implements the LDFA anonymization method.  
- `simple_face_anon.py` - This script implements the naive anonymization methods cropping, gaussian noise and pixelaziation which are applied on detected faces. 

### Bash Scripts

- `setup_requirements.sh` - Downloads `stable-diffusion-2-inpainting` weights from HuggingFace, saves it at `models/stable-diffusion` with the name `last.ckpt`.
- `setup_compose_env.sh` - Creates `.env` which includes port, directories (input, output) and image extension.
- `generate_masks.sh` - Runs `detect_faces.py` in the container.
- `anonymize.sh` - Runs `ldfa_face_anon.py` in the container.


# Citation

If you are using LDFA in your research, please consider to cite us.

```bibtex
@InProceedings{Klemp_2023_CVPR,
    author    = {Klemp, Marvin and R\"osch, Kevin and Wagner, Royden and Quehl, Jannik and Lauer, Martin},
    title     = {LDFA: Latent Diffusion Face Anonymization for Self-Driving Applications},
    booktitle = {Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR) Workshops},
    month     = {June},
    year      = {2023},
    pages     = {3198-3204}
}
```