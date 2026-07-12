import os
import shutil
from datetime import datetime

SOURCE = "./important_data"
DESTINATION_ROOT = "/backup/location"

if not os.path.exists(SOURCE):
    raise SystemExit(f"Source folder not found: {SOURCE}")

os.makedirs(DESTINATION_ROOT, exist_ok=True)
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
destination = os.path.join(DESTINATION_ROOT, f"backup_{timestamp}")
shutil.copytree(SOURCE, destination)
print(f"Backup created at {destination}")
