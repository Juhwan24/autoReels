import os
from urllib.request import Request
from urllib.request import urlopen
from bs4 import BeautifulSoup
from dotenv import load_dotenv

load_dotenv()

URL=os.getenv('BASE_URL')
TAG=os.getenv('BASE_TAG')
ATT=os.getenv('BASE_ATT')

soup=BeautifulSoup(urlopen(Request(URL,headers={'User-Agent':'Mozila/5.0'})))
objects = soup.find_all(TAG)
post_list=[]
index=0
# print("result :",objects)
for article in objects:
    print(TAG, "exact names :",article)


print(URL)



