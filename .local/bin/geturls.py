#!/usr/bin/env python
""" Get URLs from a Firefox sessionstore file """

import json
import sys

F = open(sys.argv[1], "r")
JDATA = json.loads(F.read())
F.close()
for win in JDATA.get("windows"):
    for tab in win.get("tabs"):
        i = tab.get("index") - 1
        print(tab.get("entries")[i].get("url"))
