# Copyright (c) 2008-2020 Thomas Perl <m@thp.io>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

import json
import re

from urlwatch import filters


class AmoRegexMatchUrlFilter(filters.RegexMatchFilter):
    """Get release version, creation time, sha256 hash, and release notes from AMO"""

    MATCH = {
        "url": re.compile("https://addons.mozilla.org/api/v4/addons/addon/.*")
    }

    def filter(self, data):
        api = json.loads(data)
        # jq '.current_version | .version, (.files[0] | .created, .hash), .release_notes."en-US"'  # noqa: E501
        version = api["current_version"]
        file = version["files"][0]
        content = [
            version["version"],
            file["created"],
            file["hash"],
            version["release_notes"]["en-US"],
        ]
        release = "\n".join(content).strip()
        return release


class PypiRegexMatchUrlFilter(filters.RegexMatchFilter):
    """Get release version, creation time, and sha256 hash from PyPI"""

    MATCH = {"url": re.compile("https://pypi.org/pypi/.*/json")}

    def filter(self, data):
        api = json.loads(data)
        # jq ".info.version, (.urls[-1] | .upload_time, .digests.sha256)"
        file = api["urls"][-1]
        content = [
            api["info"]["version"],
            file["upload_time"],
            file["digests"]["sha256"],
        ]
        release = "\n".join(content).strip()
        return release
