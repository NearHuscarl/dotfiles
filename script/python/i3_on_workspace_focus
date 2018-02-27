#!/bin/env python

""" this code will run when change focus in workspace """

import i3ipc

# pylint: disable=invalid-name
i3 = i3ipc.Connection()

def set_web_layout_to_tab(event):
	""" because i3 do not support different layouts (stack, tabbed, split) on different
	workspaces dynamically. https://github.com/i3/i3/issues/531 """
	if event.current and event.current.num == 3: # $ws_web. see ~/.config/i3/config
		i3.command('layout tabbed')

# pylint: disable=unused-argument
def on_workspace_focus(self, event):
	""" change web workspace to tabbed layout on focus """
	set_web_layout_to_tab(event)

try:
	i3.on('workspace::focus', on_workspace_focus)
	i3.main()
except KeyboardInterrupt:
	pass
