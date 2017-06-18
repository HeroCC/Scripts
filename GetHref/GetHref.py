from bs4 import BeautifulSoup

html = open("page.html")
page = BeautifulSoup(html, "html.parser")
href_tags = page.find_all(href=True)
for a in href_tags:
    print(a['href'])
