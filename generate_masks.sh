#!/bin/bash

# Read image extension
read -p "Enter the image extension (default jpg): " image_extension
image_extension=${image_extension:-jpg}

read -p "Enter the detection threshold (default 0.3): " detection_threshold
detection_threshold=${detection_threshold:-0.3}

sudo docker compose exec anon python3 /tool/scripts/detect_faces.py --image_dir=/data/images --mask_dir=/data/masks --image_extension=${image_extension} --threshold=${detection_threshold}