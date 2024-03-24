import requests
import time
import datetime
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def get_random_quote():
    url = 'https://api.quotable.io/random'
    response = requests.get(url, verify=False)
    quote = response.json()
    return [quote['content'], quote['author']]

while True:
    content, author = get_random_quote()
    print(f'Quote: {content} - {author} - {datetime.datetime.now()}')
    time.sleep(30)
