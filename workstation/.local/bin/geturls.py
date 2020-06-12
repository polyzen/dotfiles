#!/usr/bin/env python
""" Parse URLs from Firefox sessionstore JSON.
Requires https://github.com/andikleen/lz4json.

Examples::

    lz4jsoncat recovery.jsonlz4 | geturls.py

    geturls.py <(lz4jsoncat recovery.jsonlz4)
"""

import fileinput
import json


def get_urls(line):
    session = json.loads(line)
    for win in session.get("windows"):
        for tab in win.get("tabs"):
            i = tab.get("index") - 1
            url = tab.get("entries")[i].get("url")
            print(url)


for line in fileinput.input():
    get_urls(line)
