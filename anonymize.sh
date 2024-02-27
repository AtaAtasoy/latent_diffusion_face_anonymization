#!/bin/bash

# Load environment variables
read -p "Enter the image extension (default jpg): " image_extension
image_extension=${image_extension:-jpg}

sudo docker compose exec anon python3 /tool/scripts/ldfa_face_anon.py --image_dir=/data/images --mask_dir=/data/masks --output_dir=/data/anonymized --image_extension=${image_extension}