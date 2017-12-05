#!/bin/env python

# pylint: disable=unused-import
import sys
import os

pyrc_path = os.path.join(os.environ['HOME'], '.pythonrc.py')

# pylint: disable=exec-used
with open(pyrc_path) as file:
	code = compile(file.read(), "code_object.py", 'exec')
	exec(code)

# Do stuff here for polybar_module environemnt only
# pylint: disable=wrong-import-position
import logging
import feedparser

import requests
from requests.exceptions import HTTPError, Timeout
from bs4 import BeautifulSoup as soup

# vim: nofoldenable
