#!/bin/bash env python

"""
News module for polybar that fetch news title
from various websites and put them on polybar
"""

import random
import time
import re
import urllib.request
import sys

from threading import Thread
from bs4 import BeautifulSoup as soup

class News(object):
	"""
	Store headlines from various websites, print it and update content
	periodically
	"""

	def __init__(self, data):
		"""
		Assign data to self.cache
		data is a dictionary which store info about a specific webpage
		to be able to fetch it later using self.update()
		"""
		self.cache = data

	def update(self):
		""" Fetch titles from the web and store it in self.cache """

		for index, page in enumerate(self.cache):
			print('fetch...')

			try:
				html = urllib.request.urlopen(page['url']).read()
			except urllib.error.HTTPError:
				print('Bad connection')

			soup_html = soup(html, 'html.parser')
			attr = {page['attr']['name']: re.compile(page['attr']['value'])}
			news_list = soup_html.find_all(page['element'], **attr)

			self.cache[index]['content'] = [news.string.strip() for news in news_list]

			# print('fetch done!')
			# print('fetch test: ' + str(page['content']))

	def display(self):
		""" Print out titles from the web randomly """

		rand_index = random.randint(0, len(self.cache) - 1)
		if len(self.cache[rand_index]['content']) == 0:
			print('content is empty. Nothing to print')
			return 1

		rand_content_index = random.randint(0, len(self.cache[rand_index]['content']) - 1)

		print('update...')
		print(self.cache[rand_index]['content'][rand_content_index])

def update_news(news):
	"""
	Update news periodically, endless loop,
	use in parellel with display_news
	"""
	while True:
		# time.sleep(50)
		time.sleep(5)
		news.update()

def display_news(news):
	"""
	Display news periodically, endless loop,
	use in parellel with update_news
	"""
	while True:
		# time.sleep(10)
		time.sleep(2)
		news.display()


def main():
	""" main function """

	data = [
			{
				'name': 'mythologicinteractive',
				'url': 'http://mythologicinteractive.com/',
				'element': 'a',
				'attr': {
					'name': 'href',
					'value': 'Blog/'
					},
				'content': [],
				'format': '',
				'last_time': 20
				},
			{
				'name': '/r/RimWorld',
				'url': 'https://www.reddit.com/r/RimWorld/new',
				'element': 'a',
				'attr': {
					'name': 'data-event-action',
					'value': 'title'
					},
				'content': [],
				'format': '',
				'last_time': 1.5
				}
			]

	news = News(data)

	# update = Thread(target=lambda: update_news(news))
	# display = Thread(target=lambda: display_news(news))

	# update.start()
	# display.start()

	news.update()
	news.display()

main()

# vim: nofoldenable
