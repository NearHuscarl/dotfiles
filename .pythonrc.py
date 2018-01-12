#!/bin/env python

"""
This file is executed everytime before python interactive shell is run
to setup stuff. Remember to put export PYTHONSTARTUP=$HOME/.pythonrc.py
in .bashrc
"""

# pylint: disable=unused-import

# Import common modules
import os
import sys
from pprint import pprint as p

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

# pylint: disable=too-few-public-methods
class Exit(object):
	""" hack to alias e to sys.exit() because CTRL-D is mapped to something else in i3wm """
	def __repr__(self):
		sys.exit()

# Caveat: do not assign e to something else
# Do not use e like in print(e) or it will exit the shell
e = Exit()

# Import common module
# pylint: disable=wrong-import-position
from datetime import datetime
import time

def get_var_name(obj, namespace):
	""" return variable name. Only work with one variable assignment """
	return ''.join([name for name in namespace if namespace[name] is obj])

def debug(varname, delimiter='\n'):
	""" Print variable name and its value """
	print(str(get_var_name(varname, globals())) + ': ' + str(varname), end=delimiter)

def find_defining_class(obj, method_name):
	"""
	take a method argument and return class name that define it. Useful when
	debug in inheritance. Usage: >>> find_defining_class(Dog, 'eat') -> <class=Animal>
	"""
	for class_name in type(obj).mro():
		if method_name in class_name.__dict__:
			return class_name

dict1 = {'one': 'mot', 'two': 'hai', 'three': 'ba', 'four': 'bon'}
dict2 = {'dog': 'cat', 'rich': 'poor', 'me': 'you'}

list1 = ['this', 'is', 'an', 'example', 'list']
list2 = ['another', 'example', 'list', 'to', 'test']

str1 = 'I hate monday'
str2 = 'some random string val'

int1 = 1
int2 = -9

float1 = 5.00
float2 = -6.9

print()
debug(dict1)
debug(dict2, delimiter='\n\n')
debug(list1)
debug(list2, delimiter='\n\n')
debug(str1)
debug(str2, delimiter='\n\n')
debug(int1)
debug(int2, delimiter='\n\n')
debug(float1)
debug(float2, delimiter='\n\n')

# vim: nofoldenable
