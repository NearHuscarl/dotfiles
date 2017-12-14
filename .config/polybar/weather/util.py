#!/bin/env python

""" util functions for polybar """

import os

def color_polybar(string, color_envron_var):
	"""
	Return string with color using polybar format, for printing on polybar only,
	second argument is environment variable from $HOME/themes/current_theme
	"""

	color_begin = '%{F' + os.environ[color_envron_var] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

def color_bash(string, color):
	""" print string with escape code for bash color """

	color_code = {
			'black': '\x1b[30m',
			'red': '\x1b[31m',
			'green': '\x1b[32m',
			'yellow': '\x1b[33m',
			'blue': '\x1b[34m',
			'magenta': '\x1b[35m',
			'cyan': '\x1b[36m',
			'lightgray': '\x1b[37m',
			'darkgray': '\x1b[90m',
			'lightred': '\x1b[91m',
			'lightgreen': '\x1b[92m',
			'lightyellow': '\x1b[93m',
			'lightblue': '\x1b[94m',
			'lightmagenta': '\x1b[95m',
			'lightcyan': '\x1b[96m',
			'white': '\x1b[97m',
			'reset': '\x1b[0m'
			}

	return color_code[color] + string + color_code['reset']

def main():
	""" main function """

	print(color_polybar('test', 'THEME_BLACK'))
	print(color_bash('test', 'black'))
	print(color_bash('test', 'red'))
	print(color_bash('test', 'green'))
	print(color_bash('test', 'yellow'))
	print(color_bash('test', 'blue'))
	print(color_bash('test', 'magenta'))
	print(color_bash('test', 'cyan'))
	print(color_bash('test', 'lightgray'))
	print(color_bash('test', 'darkgray'))
	print(color_bash('test', 'lightred'))
	print(color_bash('test', 'lightgreen'))
	print(color_bash('test', 'lightyellow'))
	print(color_bash('test', 'lightblue'))
	print(color_bash('test', 'lightmagenta'))
	print(color_bash('test', 'lightcyan'))
	print(color_bash('test', 'white'))

if __name__ == '__main__':
	main()

# vim: nofoldenable
