import argparse
import os
from tqdm import tqdm
from retinaface import RetinaFace
import json


def detect(*, img_path, threshold=0.3):
    faces_detected = RetinaFace.detect_faces(img_path=img_path, threshold=threshold)
    faces = []
    for k in faces_detected:
        if type(k) != str:
            continue

        face = faces_detected[k]
        bl = [face["facial_area"][0], face["facial_area"][1]]
        tr = [face["facial_area"][2], face["facial_area"][3]]
        h = tr[1] - bl[1]

        conf = face["score"]
        tl = [bl[0], bl[1]+h]
        br = [tr[0], tr[1]-h]
        faces.append([int(tl[0]), int(tl[1]), int(br[0]), int(br[1]), float(conf)])

    return faces


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--image_dir', required=True, type=str, help='Path to input directory')
    parser.add_argument('--mask_dir', required=True, type=str, help='Path to masks (output) directory')
    parser.add_argument('--threshold', type=float, default=0.3, help='Threshold for face detection')
    parser.add_argument('--image_extension', type=str, default='jpg', help='Image extension to look for in the input directory')
    args = parser.parse_args()

    input_path = args.image_dir
    output_path = args.mask_dir
    img_extension = args.image_extension
    detection_treshold = float(args.threshold)


    img_paths = [img for img in list(os.listdir(input_path)) if img.endswith(img_extension)]
    for image in tqdm(img_paths):
        img_path = f"{input_path}/{image}"
        print(img_path)
        faces = detect(img_path=img_path, threshold=detection_treshold)

        os.makedirs(f"{output_path}", exist_ok=True)
        output_file = f"{output_path}/{os.path.splitext(os.path.basename(img_path))[0]}.json"
        print(output_file)
        with open(output_file, 'w+', encoding='utf8') as json_file:
            json.dump({"face": faces}, json_file)
