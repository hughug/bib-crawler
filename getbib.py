#!/usr/bin/env python
# functions for extracting bibtex from INSPIRE-HEP -- get contents of bibtex 
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

def main(num_entry):
	return soup.find_all('pre')[num_entry].text

if __name__=='__main__':
	sys.stdout.write("%s\n" % main(int(str(sys.argv[2]))))