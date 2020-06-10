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

from requests import get
from subprocess import run, PIPE
from urlwatch import jobs


def retrieve_and_filter(url, jqfilter):
    """Retrieve an API and parse with jq"""
    r = get(url)
    r.raise_for_status()
    p = run(
        ["jq", "--raw-output", "--exit-status", jqfilter],
        input=r.text,
        stdout=PIPE,
        encoding="utf-8",
    )
    return p.stdout


class AMOJob(jobs.Job):
    """Get release version, creation time, sha256 hash, and release notes from AMO"""

    __kind__ = "amo"
    __required__ = ("extension",)

    def get_location(self):
        return "{} (AMO)".format(self.extension)

    def retrieve(self, job_state):
        url = "https://addons.mozilla.org/api/v4/addons/addon/" + self.extension
        jqfilter = '.current_version | .version, (.files[0] | .created, .hash), .release_notes."en-US"'  # noqa: E501
        return retrieve_and_filter(url, jqfilter)


class PyPIJob(jobs.Job):
    """Get release version, creation time, and sha256 hash from PyPI"""

    __kind__ = "pypi"
    __required__ = ("package",)

    def get_location(self):
        return "{} (PyPI)".format(self.package)

    def retrieve(self, job_state):
        url = "https://pypi.org/pypi/" + self.package + "/json"
        jqfilter = ".info.version, (.urls[-1] | .upload_time, .digests.sha256)"
        return retrieve_and_filter(url, jqfilter)
