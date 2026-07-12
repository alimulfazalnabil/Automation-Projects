from pathlib import Path

FOLDER = Path("./target_folder")
PREFIX = "vacation_"
EXTENSION = ".jpg"

if not FOLDER.exists():
    raise SystemExit(f"Folder not found: {FOLDER}")

files = sorted([p for p in FOLDER.iterdir() if p.is_file()])
for index, path in enumerate(files, start=1):
    new_name = f"{PREFIX}{index:03d}{EXTENSION or path.suffix}"
    destination = FOLDER / new_name
    path.rename(destination)
    print(f"Renamed {path.name} -> {destination.name}")

print("Batch rename complete.")
