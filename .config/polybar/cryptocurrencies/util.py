#!/bin/env python

""" util functions for polybar news module """

import os

color_code = {
		'bash': {
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
			},
		'polybar': {
			'main': '%{F' + os.environ['THEME_MAIN'] + '}',
			'black': '%{F' + os.environ['THEME_BLACK'] + '}',
			'red': '%{F' + os.environ['THEME_RED'] + '}',
			'green': '%{F' + os.environ['THEME_GREEN'] + '}',
			'yellow': '%{F' + os.environ['THEME_YELLOW'] + '}',
			'blue': '%{F' + os.environ['THEME_BLUE'] + '}',
			'magenta': '%{F' + os.environ['THEME_MAGENTA'] + '}',
			'cyan': '%{F' + os.environ['THEME_CYAN'] + '}',
			'gray': '%{F' + os.environ['THEME_LIGHTGREY'] + '}',
			'white': '%{F' + os.environ['THEME_WHITE'] + '}',
			'reset': '%{F-}'
			}
		}

def color_polybar(string, color):
	"""
	Return string with color using polybar format, for printing on polybar only,
	second argument is environment variable from $HOME/themes/current_theme
	"""
	return color_code['polybar'][color] + string + color_code['polybar']['reset']

def color_bash(string, color):
	""" print string with escape code for bash color """
	return color_code['bash'][color] + string + color_code['bash']['reset']

def main():
	for color in color_code['bash']:
		print(color_bash('test', color))
	for color in color_code['polybar']:
		print(color_polybar('test', color))

if __name__ == '__main__':
	main()

# vim: nofoldenable
