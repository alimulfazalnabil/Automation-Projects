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
