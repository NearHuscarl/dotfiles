#!/usr/bin/env python

"""
This script sync the content of i3/config.win from i3/config.ctrl
config.ctrl is i3 config file with ctrl is the modifier key
config.win  is i3 config file with win  is the modifier key
"""

import os
from os import path

home_dir = os.environ['HOME']
i3_ctrl = path.join(home_dir, '.config/i3/config.ctrl')
i3_win = path.join(home_dir, '.config/i3/config.win')

if path.isfile(i3_ctrl):
	with open(i3_ctrl, 'r') as file:
		filedata = file.read()

	filedata = filedata.replace('Control', 'Mod4')

	with open(i3_win, 'w') as file:
		file.write(filedata)

# vim: nofoldenable
