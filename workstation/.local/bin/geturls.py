#!/usr/bin/env python
""" Parse URLs from Firefox sessionstore JSON.
.jsonlz4 can be extracted using https://github.com/andikleen/lz4json.

Examples::

    lz4jsoncat recovery.jsonlz4 | geturls.py

    geturls.py <(lz4jsoncat recovery.jsonlz4)
"""

import fileinput
import json


def get_urls(line):
    session = json.loads(line)
    for win in session["windows"]:
        for tab in win["tabs"]:
            i = tab["index"] - 1
            url = tab["entries"][i]["url"]
            print(url)


for line in fileinput.input():
    get_urls(line)
