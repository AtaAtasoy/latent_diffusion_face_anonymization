#!/bin/bash

# Ask for images directory
read -p "Enter the image directory: " images_volume
echo "The images volume is: $images_volume"

# Ask for output directory
read -p "Enter the output directory [default: ${images_volume}]: " output_directory
output_directory=${output_directory:-$images_volume}
echo "Output directory set to: $output_directory"

# Prepare volumes based on user input
masks_volume="${output_directory}/masks"
echo "Masks volume set to: $masks_volume"
anonymized_volume="${output_directory}/anonymized"
echo "Anonymized volume set to: $anonymized_volume"

# Ask gpu device id 
read -p "Enter the device ID for GPU (default 0): " device_id
device_id=${device_id:-0}
echo "Device ID set to: $device_id"

# Ask for docker port
read -p "Enter the port for the docker container (default 7680): " port
port=${port:-7680}
echo "Port set to: $port"

# Ask for image extension
read -p "Enter the image extension (default jpg): " image_extension
image_extension=${image_extension:-jpg}
echo "Image extension set to: $image_extension"

# Export variables for docker-compose
#export IMAGES_VOLUME=$images_volume
#export MASKS_VOLUME=$masks_volume
#export ANONYMIZED_VOLUME=$anonymized_volume
#export DEVICE_ID=$device_id
#export PORT=$port

# Create .env file
echo "PORT=$port" > .env
echo "MASKS_VOLUME=$masks_volume" >> .env
echo "IMAGES_VOLUME=$images_volume" >> .env
echo "ANONYMIZED_VOLUME=$anonymized_volume" >> .env
echo "DEVICE_ID=$device_id" >> .env
echo "IMAGE_EXTENSION=$image_extension" >> .env

# Run docker-compose
echo "Environment variables set. You can now run (sudo) docker compose up."