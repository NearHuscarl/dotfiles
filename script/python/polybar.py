#!/bin/env python

""" util functions for polybar module """

import os
import sys

colors = {
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

def cprint(string, **colorkwargs):
	""" print string + color on polybar bar. Example:
	cprint('{red}icon {gray}text{reset}')
	cprint('{red}icon {color}text{reset}', color=blue)
	"""
	colorkwargs = {key: colors[value] for key, value in colorkwargs.items()}
	colors.update(colorkwargs)
	sys.stdout.write(string.format(**colors))

def fmtstr(string, color):
	"""
	Return string with color using polybar format, for printing on polybar only,
	second argument is environment variable from $HOME/themes/current_theme
	"""
	return colors['polybar'][color] + string + colors['polybar']['reset']

def main():
	cprint('{main}test{reset}')
	cprint('{black}test{reset}')
	cprint('{red}test{reset}')
	cprint('{green}test{reset}')
	cprint('{yellow}test{reset}')
	cprint('{blue}test{reset}')
	cprint('{magenta}test{reset}')
	cprint('{cyan}test{reset}')
	cprint('{gray}test{reset}')
	cprint('{white}test{reset}')

if __name__ == '__main__':
	main()

# vim: nofoldenable
