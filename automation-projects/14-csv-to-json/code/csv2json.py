import csv
import json
import os
from pathlib import Path

SOURCE_FOLDER = Path("./csv_files")
OUTPUT_FOLDER = Path("./json_files")
OUTPUT_FOLDER.mkdir(exist_ok=True)

for csv_path in SOURCE_FOLDER.glob("*.csv"):
    with csv_path.open("r", encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    output_path = OUTPUT_FOLDER / f"{csv_path.stem}.json"
    with output_path.open("w", encoding="utf-8") as handle:
        json.dump(rows, handle, indent=2)
    print(f"Converted {csv_path.name} -> {output_path.name}")
