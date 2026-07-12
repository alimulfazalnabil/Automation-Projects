import os
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

INPUT_FOLDER = Path("./images")
OUTPUT_FOLDER = Path("./watermarked")
WATERMARK_TEXT = "© Your Name"

OUTPUT_FOLDER.mkdir(exist_ok=True)

for image_path in INPUT_FOLDER.iterdir():
    if not image_path.is_file() or image_path.suffix.lower() not in {".jpg", ".jpeg", ".png"}:
        continue

    image = Image.open(image_path).convert("RGBA")
    draw = ImageDraw.Draw(image)
    font = ImageFont.load_default()
    text_width, text_height = draw.textbbox((0, 0), WATERMARK_TEXT, font=font)[2:]

    x = image.width - text_width - 20
    y = image.height - text_height - 20
    draw.text((x, y), WATERMARK_TEXT, font=font, fill=(255, 255, 255, 128))
    image.save(OUTPUT_FOLDER / image_path.name)
    print(f"Watermarked {image_path.name}")
