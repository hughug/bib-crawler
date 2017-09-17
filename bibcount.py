#!/usr/bin/env python
# functions for extracting bibtex from INSPIRE-HEP -- get number of entries
# Baoyi Chen 2017

import sys
from bs4 import BeautifulSoup
import requests

# get the html source
resp = requests.get(str(sys.argv[1]))
txt = resp.text
soup = BeautifulSoup(txt, 'lxml')

# bibtex entries are listed between html tag '<pre>'
# get the number of `<pre>` tags

NumPre = len(soup.find_all('pre'))
print(NumPre)