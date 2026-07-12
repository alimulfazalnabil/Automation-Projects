import hashlib
from pathlib import Path

FOLDER = Path("./target")
checksum_map = {}

for path in FOLDER.rglob("*"):
    if path.is_file():
        digest = hashlib.md5(path.read_bytes()).hexdigest()
        if digest in checksum_map:
            print(f"Duplicate found: {path} matches {checksum_map[digest]}")
        else:
            checksum_map[digest] = str(path)

print("Scan complete.")
