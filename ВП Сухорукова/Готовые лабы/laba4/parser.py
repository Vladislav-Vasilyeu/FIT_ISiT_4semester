from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.service import Service
from webdriver_manager.firefox import GeckoDriverManager
from bs4 import BeautifulSoup
import time
import csv


options = webdriver.FirefoxOptions()
options.headless = True
driver = webdriver.Firefox(service=Service(GeckoDriverManager().install()), options=options)


url = "https://oz.by/sseries/more1505725.html"
driver.get(url)


time.sleep(5)


soup = BeautifulSoup(driver.page_source, 'html.parser')

books = soup.find_all('article', class_='products__item')


book_data = []


for book in books:
    title = book.find('h3', class_='product-card__title')
    price = book.find('b', class_='text-primary')

    if title and price:
        title_text = title.text.strip()
        price_text = price.text.strip()
        book_data.append([title_text, price_text])


with open('books_data.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['Book Title', 'Price'])
    writer.writerows(book_data)


driver.quit()


for data in book_data:
    print(f"Book: {data[0]}, Price: {data[1]}")
