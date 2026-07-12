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
