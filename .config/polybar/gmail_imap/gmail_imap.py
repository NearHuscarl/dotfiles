#!/bin/env python

# -*- coding: utf-8 -*-

import imaplib
import os

def color_string(string):
	""" Print output in color in polybar format """

	# Environment variables in $HOME/bin/export
	color_begin = '%{F' + os.environ['THEME_MAIN'] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

username = '16520846@gm.uit.edu.vn'

paren_dir = os.path.dirname(os.path.realpath(__file__))
passwd_path = os.path.join(paren_dir, 'gmail_pass.txt')

with open(passwd_path, 'r') as file:
	password = file.read().replace('\n', '')

mail = imaplib.IMAP4_SSL('imap.gmail.com', '993')
mail.login(username, password)
mail.select('inbox')
new_mail_count = str(len(mail.search(None, 'unseen')[1][0].decode('utf-8').split()))

print(color_string('') + ' ' + new_mail_count)

# vim: nofoldenable
