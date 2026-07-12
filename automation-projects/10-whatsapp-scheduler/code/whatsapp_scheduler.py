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
