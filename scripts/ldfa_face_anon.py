import argparse

import diffusion_face_anonymisation.utils as dfa_utils
import diffusion_face_anonymisation.io_functions as dfa_io
#import latent_diffusion.scripts.inpaint as inpaint

from PIL import Image
import numpy as np
from pathlib import Path
import os
from tqdm import tqdm
import logging

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--image_dir', type=str, required=True)
    parser.add_argument('--mask_dir', type=str, required=True)
    parser.add_argument('--output_dir', type=str, required=True)
    parser.add_argument('--image_extension', type=str, default="png")
    args = parser.parse_args()

    image_dir = args.image_dir
    mask_dir = args.mask_dir
    output_dir = args.output_dir
    image_extension = args.image_extension
    img_files = dfa_io.glob_files_by_extension(image_dir, image_extension)
    json_files = dfa_io.glob_files_by_extension(mask_dir, "json")

    debug_dir = os.path.join(output_dir, "debug")
    os.makedirs(debug_dir, exist_ok=True)
    logging.basicConfig(
        level=logging.DEBUG,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        filename=os.path.join(debug_dir, "augmentation.log"),
        filemode="w+",
    )

    image_mask_dict = {}
    image_mask_dict = dfa_utils.add_file_paths_to_image_mask_dict(json_files, image_mask_dict, "mask_file")
    image_mask_dict = dfa_utils.add_file_paths_to_image_mask_dict(img_files, image_mask_dict, "image_file")
    # clear image_mask_dict from entries that do not contain a mask
    image_mask_dict = {entry: image_mask_dict[entry] for entry in image_mask_dict if "mask_file" in image_mask_dict[entry]}

    # Print the number of masks and images
    logging.info(f"Found {len(image_mask_dict)} images with masks")
    
    print("Inpaint faces on all images:")
    for entry in tqdm(image_mask_dict.values()):
        image = Image.open(entry["image_file"])
        debug_img = np.array(image)

        all_faces_bb_list = dfa_utils.get_face_bounding_box_list_from_file(entry["mask_file"])
        mask_dict_list = dfa_utils.convert_bb_to_mask_dict_list(all_faces_bb_list, image_width=image.width, image_height=image.height)
        # Log the number of faces found in the image
        logging.info(f"Found {len(mask_dict_list)} faces in image {Path(entry['image_file']).stem}")

        # Get the composite mask
        composite_mask = dfa_utils.get_composite_mask(mask_dict_list, image_width=image.width, image_height=image.height)
        # Save the composite mask
        composite_mask.save(os.path.join(mask_dir, f"{Path(entry['image_file']).stem}_composite_mask.png"))

        inpainted_img_list = []
        logging.debug(f"Found {len(mask_dict_list)} faces in image {Path(entry['image_file']).stem}")
        for (index, mask_dict) in enumerate(mask_dict_list):
            mask = Image.fromarray(mask_dict["mask"])
            #mask_area = np.where(mask == 255)
            mask_area = np.argwhere(mask == 255)
            debug_img[mask_area] = (255, 255, 255)
            #mask.save(os.path.join(mask_dir, f"{Path(entry['image_file']).stem}_mask{index}.png"))
            #inpainted_img_list.append(image, mask)
            
            #inpaint.execute_inpaint(image_dir, output_dir, 50)
            #try:
                #inpainted_img_list.append(dfa_utils.request_inpaint(init_img=image, mask=mask))
            #except:
                #logging.error(f"API Error while inpainting: {entry['image_file']}")
            
        
        #final_img = dfa_utils.add_inpainted_faces_to_orig_img(image, inpainted_img_list, mask_dict_list)
        #orig_file = Path(entry["image_file"])

        #output_filename = Path(f"{orig_file.stem}_dfa{orig_file.suffix}")
        #debug_img_filename = Path(f"debug_{orig_file.stem}_dfa{orig_file.suffix}")
        #output_path = Path(output_dir, output_filename)
        #final_img.save(str(output_path))
        #debug_output_path = Path(output_dir, "debug", output_filename)
        #Image.fromarray(debug_img).save(str(debug_output_path))
