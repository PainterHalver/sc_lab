import requests
import time
import datetime
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

PROXY_ADDRESS = '127.0.0.1:8080'
session = requests.Session()

session.proxies.update({
    'http': 'http://' + PROXY_ADDRESS,
    'https': 'http://' + PROXY_ADDRESS
})

def get_random_quote():
    url = 'https://api.quotable.io/random'
    response = session.get(url, verify=False)
    quote = response.json()
    return [quote['content'], quote['author']]

while True:
    content, author = get_random_quote()
    print(f'Quote: {content} - {author} - {datetime.datetime.now()}')
    time.sleep(60)
