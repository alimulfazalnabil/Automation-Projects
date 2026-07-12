import os
from datetime import datetime

import mss

OUTPUT_ROOT = "./screenshots"
os.makedirs(OUTPUT_ROOT, exist_ok=True)

date_folder = datetime.now().strftime("%Y-%m-%d")
out_dir = os.path.join(OUTPUT_ROOT, date_folder)
os.makedirs(out_dir, exist_ok=True)

with mss.mss() as sct:
    file_name = datetime.now().strftime("screenshot_%H%M%S.png")
    output_path = os.path.join(out_dir, file_name)
    sct.shot(output=output_path)
    print(f"Saved screenshot to {output_path}")
