import os
import shutil
import time
from pathlib import Path

SOURCE = Path(os.path.expanduser("~/Desktop"))
ARCHIVE = SOURCE / "Archive"
DAYS = 30

ARCHIVE.mkdir(exist_ok=True)
cutoff = time.time() - (DAYS * 86400)

for path in SOURCE.iterdir():
    if path.is_file() and path.stat().st_mtime < cutoff:
        destination = ARCHIVE / path.name
        shutil.move(str(path), str(destination))
        print(f"Moved {path.name} to {destination}")

print("Cleanup complete.")
