#!/usr/bin/env python

"""
follow the instruction here: https://developers.google.com/gmail/api/quickstart/python
to generate client_secret.json and put it in $(pwd)/gmail/
Dependencies: google-api-python-client
"""

import os
import time
import httplib2

from apiclient import discovery, errors
from oauth2client.file import Storage
from oauth2client import client
from oauth2client import tools

def get_credentials():
	"""
	Gets valid user credentials from storage.

	If nothing has been stored, or if the stored credentials are invalid,
	the OAuth2 flow is completed to obtain the new credentials.

	Returns: Credentials, the obtained credential.
	"""

	credentials_dir = os.path.dirname(os.path.realpath(__file__))

	credentials_path = os.path.join(credentials_dir, 'credentials.json')
	credentials_store = Storage(credentials_path)
	credentials = credentials_store.get()

	if not credentials or credentials.invalid:
		scope = 'https://www.googleapis.com/auth/gmail.readonly'
		client_secret_file = os.path.join(credentials_dir, 'client_secret.json')
		application_name = 'Gmail Notification - Polybar'

		flow = client.flow_from_clientsecrets(client_secret_file, scope)
		flow.user_agent = application_name
		credentials = tools.run_flow(flow, credentials_store)
	return credentials

def update_unread_gmail_count():
	""" Update unread mails in gmail and display on polybar """

	try:
		credentials = get_credentials()
		http = credentials.authorize(httplib2.Http())
		gmail = discovery.build('gmail', 'v1', http=http)

		# pylint: disable=no-member
		result = gmail.users().messages().list(userId='me', q='in:inbox is:unread').execute()
		unread_count = result['resultSizeEstimate']

		print(color_string('', 'THEME_MAIN') + ' ' + str(unread_count), flush=True)
		return 0

	except (OSError, errors.HttpError, httplib2.ServerNotFoundError):
		print(color_string('', 'THEME_ALERT'), flush=True)
		return 1

	except client.AccessTokenRefreshError:
		print(color_string('', 'THEME_ALERT'), flush=True)
		return 2

def color_string(string, color_envron_var):
	"""
	Print output in color in polybar format, second argument
	is environment variable from $HOME/themes/current_theme
	"""

	# Environment variables in $HOME/bin/export
	color_begin = '%{F' + os.environ[color_envron_var] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

def main():
	""" main function """

	result = update_unread_gmail_count()

	while True:
		if result == 0:
			time.sleep(600)
			result = update_unread_gmail_count()
		else:
			time.sleep(3)
			result = update_unread_gmail_count()

main()

# vim: nofoldenable
