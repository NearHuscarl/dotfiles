#!/bin/env python

# -*- coding: utf-8 -*-

import imaplib
import os

def color_string(string):
	""" Print output in color in polybar format """

	# Environment variables in $HOME/bin/export
	color_begin = '%{F' + os.environ['THEME_HL'] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

home_dir = os.environ['HOME']
username = '16520846@gm.uit.edu.vn'
with open(os.path.join(home_dir, '.config/polybar/gmail_pass.txt'), 'r') as file:
	password = file.read().replace('\n', '')

mail = imaplib.IMAP4_SSL('imap.gmail.com', '993')
mail.login(username, password)
mail.select('inbox')
new_mail_count = str(len(mail.search(None, 'unseen')[1][0].decode('utf-8').split()))

print(color_string('') + ' ' + new_mail_count)
