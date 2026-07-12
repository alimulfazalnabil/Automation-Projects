import hashlib
from pathlib import Path

import pandas as pd

INPUT_FILE = Path("data.csv")
OUTPUT_FILE = Path("anonymized.csv")
COLUMNS_TO_ANONYMIZE = ["Name", "Email"]

if not INPUT_FILE.exists():
    raise SystemExit(f"Input file not found: {INPUT_FILE}")

df = pd.read_csv(INPUT_FILE)
for column in COLUMNS_TO_ANONYMIZE:
    if column in df.columns:
        df[column] = df[column].apply(lambda value: hashlib.md5(str(value).encode("utf-8")).hexdigest()[:10])

df.to_csv(OUTPUT_FILE, index=False)
print(f"Saved anonymized data to {OUTPUT_FILE}")
