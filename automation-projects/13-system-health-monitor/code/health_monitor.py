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
