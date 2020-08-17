import requests
import os
from bs4 import BeautifulSoup

def getSoup(url):
    req = requests.get(url)
    soup = BeautifulSoup(req.text, "html.parser")
    return soup

def checkFiles():
    files = os.listdir(os.curdir)
    return files



url_base = "https://www.vulnhub.com/?page="

# Get last page
soup = getSoup(url_base + str(1))
div = soup.find("div", attrs={"class" : "text-center pagination"})
list_li = div.findAll("li")
last_page = int(list_li[len(list_li)-2].text)

# Get list of all urls
url_list = []
for i in range(1, last_page+1):
    url_list.append(url_base + str(i))

# Get urls of each page and save append into a file
todo_file = open("todo.txt", "w")
for url in url_list:
    soup = getSoup(url)  
    divs = soup.findAll("div", attrs={"class" : "span9 entry-title"})
    print("==== " + str(url) + " ====")
    for div in divs:
        url = "https://www.vulnhub.com/" + div.find("a")['href'] + "\n"
        todo_file.write(url)
# El script crea un archivo de pendientes y otro de máquinas hechas
# Primero buscamos si hay algún archivo histórico
#   si no lo hay tenemos que coger las url de todas las páginas
#   si lo hay tenemos que ir cogiendo las paginas una a una desde la más reciente hasta que demos con la ultima maquina guardada

