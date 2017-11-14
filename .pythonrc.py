"""
This file is executed everytime before python interactive shell is run
to setup stuff. Remember to put export PYTHONSTARTUP=$HOME/.pythonrc.py
in .bashrc
"""

# Import common modules
import os
import sys
import pprint

try:
	import requests
except ImportError:
	print('Some modules is missing')

# Fix interactive prompt with virtualenv dont have autocomplete
import rlcompleter
import readline
import atexit

histfile = os.path.join(os.path.expanduser("~"), ".pyhist")

try:
	readline.read_history_file(histfile)
	readline.set_history_length(2000) # default history len is -1 (infinite), which may grow unruly
except IOError:
	print('No history file')

atexit.register(readline.write_history_file, histfile)

# vim: nofoldenable
