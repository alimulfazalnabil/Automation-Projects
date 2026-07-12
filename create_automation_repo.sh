#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$ROOT_DIR/automation-projects"

mkdir -p "$OUTPUT_DIR"

cat > "$OUTPUT_DIR/README.md" <<'EOF'
# ⚙️ 20 Python Automation Projects

A collection of 20 practical Python automation tools covering file handling, web scraping, reporting, monitoring, document processing, and web automation.

## Project List

| # | Project | Category |
|---|---------|----------|
| 01 | Bulk File Renamer | File Management |
| 02 | Automated Email Sender | Communication |
| 03 | News Headline Scraper | Web Scraping |
| 04 | Excel Report Generator | Data Processing |
| 05 | PDF Merger & Splitter | Document Handling |
| 06 | Image Watermarker | Image Processing |
| 07 | Data Backup Script | System Utility |
| 08 | YouTube Video Downloader | Media |
| 09 | Invoice Generator | Document Creation |
| 10 | WhatsApp Message Scheduler | Messaging |
| 11 | Screenshot Taker & Organizer | System Utility |
| 12 | GitHub Repository Cloner | Developer Tools |
| 13 | System Health Monitor | System Utility |
| 14 | CSV to JSON Converter | Data Processing |
| 15 | Duplicate File Finder | File Management |
| 16 | Website Uptime Checker | Monitoring |
| 17 | Automated Form Filler | Web Automation |
| 18 | Data Anonymizer | Data Processing |
| 19 | Desktop Cleaner | File Management |
| 20 | PDF Table Extractor | Document Handling |

## How to Use

Each project contains:
- a README with setup notes
- a Python script in the code directory
- a requirements.txt file

Example:

```bash
cd automation-projects/03-news-headline-scraper
python3 -m pip install -r code/requirements.txt
python3 code/scraper.py
```
EOF

create_project() {
  local slug="$1"
  local title="$2"
  local description="$3"
  local script_name="$4"
  local requirements="$5"
  local project_dir="$OUTPUT_DIR/$slug"

  mkdir -p "$project_dir/code"

  cat > "$project_dir/README.md" <<EOF
# $title

## What It Does
$description

## How to Use
1. Open the project folder.
2. Install dependencies:
   \`python3 -m pip install -r code/requirements.txt\`
3. Run the script:
   \`python3 code/$script_name\`

## Notes
The code is intentionally simple and easy to adapt for your own workflow.
EOF

  printf '%s
' "$requirements" > "$project_dir/code/requirements.txt"
}

create_project "01-bulk-file-renamer" "Bulk File Renamer" "Rename a folder of files using a prefix and sequential numbering." "renamer.py" ""
cat > "$OUTPUT_DIR/01-bulk-file-renamer/code/renamer.py" <<'PY'
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
PY

create_project "02-automated-email-sender" "Automated Email Sender" "Send an email with an optional attachment using SMTP." "email_sender.py" ""
cat > "$OUTPUT_DIR/02-automated-email-sender/code/email_sender.py" <<'PY'
import os
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
SENDER_EMAIL = "you@gmail.com"
SENDER_PASSWORD = "app-password"
RECIPIENTS = ["recipient@example.com"]
SUBJECT = "Automation Report"
BODY = "<h2>Hello</h2><p>Your automation report is attached.</p>"
ATTACHMENT = "report.pdf"

msg = MIMEMultipart()
msg["From"] = SENDER_EMAIL
msg["To"] = ", ".join(RECIPIENTS)
msg["Subject"] = SUBJECT
msg.attach(MIMEText(BODY, "html"))

if os.path.exists(ATTACHMENT):
    with open(ATTACHMENT, "rb") as handle:
        part = MIMEBase("application", "octet-stream")
        part.set_payload(handle.read())
        encoders.encode_base64(part)
        part.add_header("Content-Disposition", f"attachment; filename={os.path.basename(ATTACHMENT)}")
        msg.attach(part)

with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
    server.starttls()
    server.login(SENDER_EMAIL, SENDER_PASSWORD)
    server.sendmail(SENDER_EMAIL, RECIPIENTS, msg.as_string())

print("Email sent successfully.")
PY

create_project "03-news-headline-scraper" "News Headline Scraper" "Collect news headlines from a website and save them as CSV data." "scraper.py" "requests\nbeautifulsoup4"
cat > "$OUTPUT_DIR/03-news-headline-scraper/code/scraper.py" <<'PY'
import csv
from datetime import datetime

import requests
from bs4 import BeautifulSoup

URL = "https://www.bbc.com/news"
HEADERS = {"User-Agent": "Mozilla/5.0"}

response = requests.get(URL, headers=HEADERS, timeout=10)
response.raise_for_status()

soup = BeautifulSoup(response.text, "html.parser")
headlines = []

for item in soup.select("a[href*='/news/'] h3"):
    text = item.get_text(strip=True)
    if text:
        headlines.append([datetime.now().strftime("%Y-%m-%d %H:%M"), text])

with open("headlines.csv", "w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["Timestamp", "Headline"])
    writer.writerows(headlines)

print(f"Saved {len(headlines)} headlines.")
PY

create_project "04-excel-report-generator" "Excel Report Generator" "Create an Excel workbook from one or more CSV files." "excel_report.py" "pandas\nopenpyxl"
cat > "$OUTPUT_DIR/04-excel-report-generator/code/excel_report.py" <<'PY'
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
PY

create_project "05-pdf-merger-splitter" "PDF Merger & Splitter" "Merge several PDF files or split a PDF into individual pages." "pdf_tool.py" "PyPDF2"
cat > "$OUTPUT_DIR/05-pdf-merger-splitter/code/pdf_tool.py" <<'PY'
import os

from PyPDF2 import PdfMerger, PdfReader, PdfWriter


def merge_pdfs(folder_path, output_name="merged.pdf"):
    merger = PdfMerger()
    for file_name in sorted(os.listdir(folder_path)):
        if file_name.endswith(".pdf"):
            merger.append(os.path.join(folder_path, file_name))
    merger.write(output_name)
    merger.close()
    print(f"Merged PDFs into {output_name}")


def split_pdf(input_path, output_folder="split"):
    os.makedirs(output_folder, exist_ok=True)
    reader = PdfReader(input_path)
    for index, page in enumerate(reader.pages, start=1):
        writer = PdfWriter()
        writer.add_page(page)
        with open(os.path.join(output_folder, f"page_{index}.pdf"), "wb") as handle:
            writer.write(handle)
    print(f"Split {len(reader.pages)} pages into {output_folder}")


merge_pdfs("./pdfs")
# split_pdf("input.pdf")
PY

create_project "06-image-watermarker" "Image Watermarker" "Add a text watermark to a batch of images." "watermark.py" "Pillow"
cat > "$OUTPUT_DIR/06-image-watermarker/code/watermark.py" <<'PY'
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
PY

create_project "07-data-backup-script" "Data Backup Script" "Copy a folder to a timestamped backup location." "backup.py" ""
cat > "$OUTPUT_DIR/07-data-backup-script/code/backup.py" <<'PY'
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
PY

create_project "08-youtube-video-downloader" "YouTube Video Downloader" "Download a single video or a playlist from YouTube." "yt_downloader.py" "pytube"
cat > "$OUTPUT_DIR/08-youtube-video-downloader/code/yt_downloader.py" <<'PY'
from pytube import Playlist, YouTube

URL = input("Enter a YouTube video or playlist URL: ").strip()

if "playlist" in URL:
    for video in Playlist(URL).video_urls:
        yt = YouTube(video)
        stream = yt.streams.get_highest_resolution()
        stream.download(output_path="./videos")
        print(f"Downloaded {yt.title}")
else:
    yt = YouTube(URL)
    stream = yt.streams.get_highest_resolution()
    stream.download(output_path="./videos")
    print(f"Downloaded {yt.title}")
PY

create_project "09-invoice-generator" "Invoice Generator" "Build a simple PDF invoice from structured data." "invoice_gen.py" "fpdf"
cat > "$OUTPUT_DIR/09-invoice-generator/code/invoice_gen.py" <<'PY'
from datetime import datetime

from fpdf import FPDF

CUSTOMER_NAME = "John Doe"
CUSTOMER_ADDRESS = "123 Main Street"
ITEMS = [
    {"description": "Web Development", "quantity": 1, "price": 500},
    {"description": "Hosting", "quantity": 1, "price": 99},
]

pdf = FPDF()
pdf.add_page()
pdf.set_font("Arial", size=12)
pdf.cell(0, 10, f"Invoice Date: {datetime.now().strftime('%Y-%m-%d')}", ln=True)
pdf.cell(0, 10, f"Bill To: {CUSTOMER_NAME}", ln=True)
pdf.cell(0, 10, CUSTOMER_ADDRESS, ln=True)
pdf.ln(10)
pdf.set_font("Arial", "B", 12)
pdf.cell(80, 10, "Description", border=1)
pdf.cell(30, 10, "Qty", border=1, align="C")
pdf.cell(30, 10, "Price", border=1, align="C")
pdf.cell(30, 10, "Total", border=1, align="C")
pdf.ln()
pdf.set_font("Arial", size=12)
for item in ITEMS:
    total = item["quantity"] * item["price"]
    pdf.cell(80, 10, item["description"], border=1)
    pdf.cell(30, 10, str(item["quantity"]), border=1, align="C")
    pdf.cell(30, 10, f"${item['price']}", border=1, align="C")
    pdf.cell(30, 10, f"${total}", border=1, align="C")
    pdf.ln()
pdf.output("invoice.pdf")
print("Invoice saved as invoice.pdf")
PY

create_project "10-whatsapp-scheduler" "WhatsApp Message Scheduler" "Schedule a WhatsApp message through the pywhatkit library." "whatsapp_scheduler.py" "pywhatkit"
cat > "$OUTPUT_DIR/10-whatsapp-scheduler/code/whatsapp_scheduler.py" <<'PY'
import datetime

import pywhatkit as kit

PHONE = "+1234567890"
MESSAGE = "Hello from an automated script"
HOUR = 14
MINUTE = 30

now = datetime.datetime.now()
target = now.replace(hour=HOUR, minute=MINUTE, second=0, microsecond=0)
if target < now:
    target += datetime.timedelta(days=1)

print(f"Sending message at {target.strftime('%H:%M')} on {target.strftime('%Y-%m-%d')}")
kit.sendwhatmsg(PHONE, MESSAGE, HOUR, MINUTE)
print("Message sent.")
PY

create_project "11-screenshot-taker-organizer" "Screenshot Taker & Organizer" "Capture a screenshot and save it in a dated folder." "screenshotter.py" "mss"
cat > "$OUTPUT_DIR/11-screenshot-taker-organizer/code/screenshotter.py" <<'PY'
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
PY

create_project "12-github-repo-cloner" "GitHub Repository Cloner" "Clone public repositories from a GitHub user account." "repo_cloner.py" "requests\ngitpython"
cat > "$OUTPUT_DIR/12-github-repo-cloner/code/repo_cloner.py" <<'PY'
import os

import requests
from git import Repo

USER = "octocat"
DESTINATION = "./github_repos"
os.makedirs(DESTINATION, exist_ok=True)

response = requests.get(f"https://api.github.com/users/{USER}/repos?per_page=100", timeout=10)
response.raise_for_status()

for repo in response.json():
    clone_url = repo["clone_url"]
    repo_name = repo["name"]
    target_path = os.path.join(DESTINATION, repo_name)
    if not os.path.exists(target_path):
        Repo.clone_from(clone_url, target_path)
        print(f"Cloned {repo_name}")
    else:
        print(f"Skipped {repo_name} (already exists)")
PY

create_project "13-system-health-monitor" "System Health Monitor" "Track CPU, RAM, and disk usage and raise alerts if thresholds are exceeded." "health_monitor.py" "psutil"
cat > "$OUTPUT_DIR/13-system-health-monitor/code/health_monitor.py" <<'PY'
import smtplib
from email.mime.text import MIMEText

import psutil

CPU_THRESHOLD = 80
RAM_THRESHOLD = 80
DISK_THRESHOLD = 90


def send_alert(message):
    msg = MIMEText(message)
    msg["Subject"] = "System Alert"
    msg["From"] = "you@gmail.com"
    msg["To"] = "admin@example.com"
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login("you@gmail.com", "app-password")
        server.sendmail("you@gmail.com", ["admin@example.com"], msg.as_string())


cpu = psutil.cpu_percent(interval=1)
ram = psutil.virtual_memory().percent
disk = max(partition.percent for partition in psutil.disk_partitions())

alerts = []
if cpu > CPU_THRESHOLD:
    alerts.append(f"CPU usage is {cpu}%")
if ram > RAM_THRESHOLD:
    alerts.append(f"RAM usage is {ram}%")
if disk > DISK_THRESHOLD:
    alerts.append(f"Disk usage is {disk}%")

if alerts:
    send_alert("\n".join(alerts))

print(f"CPU: {cpu}% | RAM: {ram}% | Disk: {disk}%")
PY

create_project "14-csv-to-json" "CSV to JSON Converter" "Convert all CSV files in a folder into JSON files." "csv2json.py" ""
cat > "$OUTPUT_DIR/14-csv-to-json/code/csv2json.py" <<'PY'
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
PY

create_project "15-duplicate-file-finder" "Duplicate File Finder" "Scan a folder for files that share the same checksum." "duplicate_finder.py" ""
cat > "$OUTPUT_DIR/15-duplicate-file-finder/code/duplicate_finder.py" <<'PY'
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
PY

create_project "16-website-uptime-checker" "Website Uptime Checker" "Check a list of sites periodically and alert when a site goes down." "uptime_checker.py" "requests"
cat > "$OUTPUT_DIR/16-website-uptime-checker/code/uptime_checker.py" <<'PY'
import smtplib
import time
from email.mime.text import MIMEText

import requests

SITES = ["https://google.com", "https://github.com"]
INTERVAL_SECONDS = 300


def alert(site, status):
    msg = MIMEText(f"{site} returned status {status}")
    msg["Subject"] = "Site down"
    msg["From"] = "you@gmail.com"
    msg["To"] = "admin@example.com"
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login("you@gmail.com", "app-password")
        server.sendmail("you@gmail.com", ["admin@example.com"], msg.as_string())


while True:
    for site in SITES:
        try:
            response = requests.get(site, timeout=5)
            if response.status_code != 200:
                alert(site, response.status_code)
                print(f"{site} returned {response.status_code}")
            else:
                print(f"{site} is up")
        except Exception as exc:
            alert(site, str(exc))
            print(f"{site} failed: {exc}")
    time.sleep(INTERVAL_SECONDS)
PY

create_project "17-automated-form-filler" "Automated Form Filler" "Use Selenium to automatically fill a web form." "form_filler.py" "selenium"
cat > "$OUTPUT_DIR/17-automated-form-filler/code/form_filler.py" <<'PY'
from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
try:
    driver.get("https://example.com/login")
    driver.find_element(By.NAME, "username").send_keys("myuser")
    driver.find_element(By.NAME, "password").send_keys("mypass")
    driver.find_element(By.CSS_SELECTOR, "button[type='submit']").click()
    print("Form submitted")
finally:
    driver.quit()
PY

create_project "18-data-anonymizer" "Data Anonymizer" "Replace sensitive values in a CSV file with hashed placeholders." "anonymize.py" "pandas"
cat > "$OUTPUT_DIR/18-data-anonymizer/code/anonymize.py" <<'PY'
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
PY

create_project "19-desktop-cleaner" "Desktop Cleaner" "Move older files from a folder to an archive directory." "desktop_cleaner.py" ""
cat > "$OUTPUT_DIR/19-desktop-cleaner/code/desktop_cleaner.py" <<'PY'
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
PY

create_project "20-pdf-table-extractor" "PDF Table Extractor" "Extract tables from a PDF and save them as CSV." "pdf_table_extract.py" "tabula-py"
cat > "$OUTPUT_DIR/20-pdf-table-extractor/code/pdf_table_extract.py" <<'PY'
import tabula

PDF_FILE = "report.pdf"
OUTPUT_FILE = "tables.csv"

try:
    tables = tabula.read_pdf(PDF_FILE, pages="all", multiple_tables=True)
    if tables:
        tables[0].to_csv(OUTPUT_FILE, index=False)
        print(f"Saved first table to {OUTPUT_FILE}")
    else:
        print("No tables found in the PDF")
except Exception as exc:
    print(f"Failed to extract tables: {exc}")
PY

chmod +x "$ROOT_DIR/create_automation_repo.sh"

cat > "$ROOT_DIR/README.md" <<'EOF'
# Automation-Projects

This workspace now contains a generator script for building a repository of 20 automation projects.

## Files
- [create_automation_repo.sh](create_automation_repo.sh) – generates the automation project structure.
- [automation-projects/README.md](automation-projects/README.md) – overview of the generated projects.

## Run
```bash
bash create_automation_repo.sh
```
EOF

echo "Created automation-projects with 20 project folders."
