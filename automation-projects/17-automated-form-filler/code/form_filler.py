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
