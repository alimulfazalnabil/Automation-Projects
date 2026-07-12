import glob
from pathlib import Path

import pandas as pd

CSV_FOLDER = Path("./csv_files")
OUTPUT_FILE = "report.xlsx"

if not CSV_FOLDER.exists():
    raise SystemExit(f"Folder not found: {CSV_FOLDER}")

writer = pd.ExcelWriter(OUTPUT_FILE)
for csv_path in sorted(CSV_FOLDER.glob("*.csv")):
    frame = pd.read_csv(csv_path)
    sheet_name = csv_path.stem[:31]
    frame.to_excel(writer, sheet_name=sheet_name, index=False)
writer.close()

print(f"Saved Excel report to {OUTPUT_FILE}")
