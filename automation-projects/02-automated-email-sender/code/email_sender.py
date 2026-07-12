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
