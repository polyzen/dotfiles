#!/usr/bin/env python
""" Parse URLs from Firefox sessionstore JSON.
Requires https://github.com/andikleen/lz4json.

Example::

    geturls.py <(lz4jsoncat ~/.mozilla/firefox/*.Default\
            \ User/sessionstore-backups/recovery.jsonlz4) | less
"""

import json
import sys

F = open(sys.argv[1], "r")
JDATA = json.loads(F.read())
F.close()
for win in JDATA.get("windows"):
    for tab in win.get("tabs"):
        i = tab.get("index") - 1
        print(tab.get("entries")[i].get("url"))
