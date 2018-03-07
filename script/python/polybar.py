#!/bin/env python

"""
============================================================================
File:        polybar.py
Description: util functions for polybar module
Author:      Near Huscarl <near.huscarl@gmail.com>
Last Change: Wed Mar 07 17:37:43 +07 2018
Licence:     BSD 3-Clause license
Note:        N/A
============================================================================
"""

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
	return colors[color] + string + colors['reset']

def main():
	cprint('{main}test{reset}\n')
	cprint('{black}test{reset}\n')
	cprint('{red}test{reset}\n')
	cprint('{green}test{reset}\n')
	cprint('{yellow}test{reset}\n')
	cprint('{blue}test{reset}\n')
	cprint('{magenta}test{reset}\n')
	cprint('{cyan}test{reset}\n')
	cprint('{gray}test{reset}\n')
	cprint('{white}test{reset}\n')

if __name__ == '__main__':
	main()

# vim: nofoldenable
