#!/usr/bin/env python
"""Parse URLs from Firefox sessionstore JSON.

.jsonlz4 can be extracted using https://github.com/andikleen/lz4json.

Examples::

    lz4jsoncat recovery.jsonlz4 | geturls.py

    geturls.py <(lz4jsoncat recovery.jsonlz4)
"""

import fileinput
import json

for line in fileinput.input():
    session = json.loads(line)
    for win in session["windows"]:
        for tab in win["tabs"]:
            i = tab["index"] - 1
            url = tab["entries"][i]["url"]
            print(url)
