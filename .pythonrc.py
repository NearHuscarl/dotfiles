#!/bin/env python

"""
This file is executed everytime before python interactive shell is run
to setup stuff. Remember to put export PYTHONSTARTUP=$HOME/.pythonrc.py
in .bashrc
"""

# pylint: disable=unused-import

# Import common modules
from datetime import datetime
from pprint import pprint as p
from code import InteractiveConsole
from tempfile import mkstemp
import os
import sys
import re
import threading
# import time

# Fix interactive prompt with virtualenv dont have autocomplete
import rlcompleter

# Fix history not working in virtualenv
import readline
import atexit

HISTFILE = os.path.join(os.path.expanduser("~"), ".pyhist")
HISTLEN = 2000

def make_history_great_again():
	""" fix history in virtualenv """
	try:
		readline.read_history_file(HISTFILE)
		readline.set_history_length(HISTLEN) # default history len is -1 (infinite)
	except IOError:
		print('No history file')
	atexit.register(readline.write_history_file, HISTFILE)

def pythonrc_set_prompt():
	""" color interactive prompt """
	if os.getenv('TERM') in ('xterm-termite', 'xterm', 'vt100', 'rxvt', 'Eterm', 'putty'):
		if 'readline' in sys.modules:
			# ^A and ^B delimit invisible characters for readline to count
			# right.
			sys.ps1 = '\001\033[0;32m\002>>> \001\033[0m\002'
			sys.ps2 = '\001\033[0;32m\002... \001\033[0m\002'
		else:
			sys.ps1 = '\033[0;32m>>> \033[0m'
			sys.ps2 = '\033[0;32m... \033[0m'

def pp(obj, *args):
	""" pretty print. lazy load pprint module """
	import pprint
	pprint.pprint(obj, *args)
	del pprint

def history(last=10, printout=True):
	""" Display last commands in history """
	global HISTFILE

	lines = ''
	length = readline.get_current_history_length()
	start = length - last
	for i in range(start, length):
		line = readline.get_history_item(i)
		if printout:
			print('{} {}'.format(i, line))
		lines += line + '\n'
	return lines.encode().split(b'\n')

class ImprovedInteractiveConsole(InteractiveConsole):
	""" Allows editing of console commands in $EDITOR """

	EDITOR = os.environ.get('EDITOR', 'vi')
	EDIT_HISTORY_RE = r'^\s*h ?[0-9]{0,3}$' # match: 'h', 'h 5', 'h 200', 'h 1000'
	DOC_RE = r'.*\?\s*$' # match: 'print?', 'request? '
	CLEAR = 'c'
	EDIT_CMD = 'v'
	EXIT = 'e'
	REPEAT = 'r'

	def __init__(self, *args, **kwargs):
		self.last_buffer = [] # This holds the last executed statement
		InteractiveConsole.__init__(self, *args, **kwargs)

	def runsource(self, source, *args):
		self.last_buffer = [source.encode('utf-8')]
		return InteractiveConsole.runsource(self, source, *args)

	def _is_custom_cmd(self, line):
		""" Return true if line is a custom command """
		if (line not in [self.CLEAR, self.EDIT_CMD, self.EXIT, self.REPEAT]
				and re.search(self.EDIT_HISTORY_RE, line) is None
				and re.search(self.DOC_RE, line) is None):
			return False
		return True

	def clear(self):
		""" Clear python shell """
		os.system('clear')
		return ''

	def print_docstring(self, line):
		""" print docstring of object. For example: 'requests?' will print help about requests"""
		try:
			obj = line.split('?')[0].strip()
			print(eval(obj).__doc__)
		except:
			pass
		finally:
			return ''

	def _edit_in_texteditor(self, content):
		""" Edit cmds in your $EDITOR. Content is a list of string which will
		be prepopulated in $EDITOR"""
		# Make temporary file
		fd, tmpfile = mkstemp('.py')

		# Write last statement to file
		os.write(fd, b'\n'.join(content))
		os.close(fd)

		# Edit file in editor
		os.system(self.EDITOR + ' ' + tmpfile)

		# Get edited statement
		line = open(tmpfile).read()
		os.remove(tmpfile)

		# Print output to python interactive shell and add to history
		lines = line.split('\n')
		for i in range(len(lines) - 1):
			if not self._is_custom_cmd(lines[i]):
				self.push(lines[i])
				readline.add_history(lines[i])
		return ''

	def edithistory(self, last=10):
		print('last: ' + str(last))
		return self._edit_in_texteditor(history(last=last, printout=False))

	def editcmd(self):
		""" Edit previous cmd in your $EDITOR """
		return self._edit_in_texteditor(self.last_buffer)

	def repeat_last_cmd(self):
		""" repeat previously typed cmd """
		index = readline.get_current_history_length()
		line = readline.get_history_item(index - 1)
		while self._is_custom_cmd(line):
			index -= 1
			line = readline.get_history_item(index)
		self.push(line)
		return ''

	def raw_input(self, *args):
		line = InteractiveConsole.raw_input(self, *args)
		if line == self.CLEAR:
			line = self.clear()
		elif re.search(self.DOC_RE, line):
			line = self.print_docstring(line)
		elif re.search(self.EDIT_HISTORY_RE, line):
			try:
				_, last = line.split()
				line = self.edithistory(int(last))
			except:
				line = self.edithistory()
		elif line == self.EDIT_CMD:
			line = self.editcmd()
		elif line == self.REPEAT:
			line = self.repeat_last_cmd()
		elif line == self.EXIT:
			sys.exit()
		return line

def find_defining_class(obj, method_name):
	"""
	take a method argument and return class name that define it. Useful when
	debug in inheritance. Usage: >>> find_defining_class(Dog, 'eat') -> <class=Animal>
	"""
	for class_name in type(obj).mro():
		if method_name in class_name.__dict__:
			return class_name
	return None

def auto_import_package():
	""" execute import_package() in another because exec() is slow """
	def import_package():
		""" auto import package if detect directory in current directory
		have __init__.py """
		cwd = os.getcwd()
		lsdir = os.listdir()
		for directory in lsdir:
			if os.path.isfile(os.path.join(cwd, directory, '__init__.py')):
				exec('import ' + directory, globals()) # pylint: disable=exec-used
	thread = threading.Thread(target=import_package)
	thread.start()

if __name__ == '__main__':
	make_history_great_again()
	pythonrc_set_prompt()
	auto_import_package()

	del make_history_great_again
	del pythonrc_set_prompt
	del auto_import_package

	# set up some variables to toy with
	dict1 = {'one': 'mot', 'two': 'hai', 'three': 'ba', 'four': 'bon'}
	dict2 = {'ny': 'new york', 'la': 'los angeles', 'tx': 'texas'}

	list1 = ['this', 'is', 'an', 'example', 'list']
	list2 = ['another', 'example', 'list', 'to', 'test']

	str1 = 'I hate monday'
	str2 = 'some random string val'

	int1 = 1
	int2 = -9

	float1 = 5.00
	float2 = -6.9

	welcome_msg = '\n'
	welcome_msg += 'dict1 = {}\n'.format(dict1)
	welcome_msg += 'dict2 = {}\n'.format(dict2)
	welcome_msg += '\n'
	welcome_msg += 'list1 = {}\n'.format(list1)
	welcome_msg += 'list2 = {}\n'.format(list2)
	welcome_msg += '\n'
	welcome_msg += 'str1 = {}\n'.format(str1)
	welcome_msg += 'str2 = {}\n'.format(str2)
	welcome_msg += '\n'
	welcome_msg += 'int1 = {}\n'.format(int1)
	welcome_msg += 'int2 = {}\n'.format(int2)
	welcome_msg += '\n'
	welcome_msg += 'float1 = {}\n'.format(float1)
	welcome_msg += 'float2 = {}\n'.format(float2)

	console = ImprovedInteractiveConsole(locals=locals())
	console.interact(banner=welcome_msg)

# vim: nofoldenable
