#!/bin/env python

"""
News module containing a news class that hold a list of Pages
it updates and displays titles and relevants info from those pages
randomly and periodicaly, updating and displaying is executed in
2 seperate threads
"""

import argparse
import logging
import os
import random
import time
from threading import Thread

from requests import ConnectionError
from requests.exceptions import HTTPError, Timeout
from page import (
		Daa,
		BeamNG,
		Cosmoteer,
		Mythologic,
		ProjectZomboid,
		RedditRimWorld,
		RedditUnixporn,
		RedditVim,
		RedditWebdev,
		HackerNoon,
		Freecodecamp
		)

class News(object):
	""" Store a list a Page, update and print in periodically """

	def __init__(self, pages):
		dirname = os.path.dirname(os.path.realpath(__file__))
		self.url_file = os.path.join(dirname, 'news_url')
		self.pages = pages
		self.size = len(self.pages)
		self.index = -1
		self.index_list = random.sample(range(0, self.size), self.size)

	def _get_index(self):
		"""
		Get current index of pages list to update the
		webpage content to avoid updating all webpages at once
		"""

		self.index += 1
		if self.index > self.size - 1:
			self.index = 0
		return self.index_list[self.index]

	def _is_content_avail(self):
		""" return True if there is content in one of the pages """

		for page in self.pages:
			if page.content:
				return True
		return False

	def _get_random_index(self):
		"""
		Return a tuple of random indexes for Page and Page.content['title'] which does 2 things:
			Get a random page
			Get a random title in that page
		"""
		page_index = random.randint(0, self.size - 1)

		# Throw error if title list len is zero
		err_msg = '{}\'s title selector not available'.format(self.pages[page_index].name)
		assert 'title' in self.pages[page_index].selector, err_msg

		try:
			title_index = random.randint(0, len(self.pages[page_index].content) - 1)
		except ValueError: # self.content is empty list => random.randint(0, -1)
			return page_index, None

		return page_index, title_index


	def update_news(self):
		"""
		Update news periodically, endless loop,
		use in parellel with display_news
		"""

		index = self._get_index()

		while True:
			try:
				self.pages[index].update()
			except (HTTPError, Timeout, ConnectionError):
				logging.info('update failed: ')
				time.sleep(2)
			else:
				logging.info('update success')
				time.sleep(30)
			finally:
				index = self._get_index()

	def display_news(self):
		"""
		Display news periodically, endless loop,
		use in parellel with update_news
		"""

		page_index, title_index = self._get_random_index()

		while True:
			try:
				self.pages[page_index].display(title_index)
			except TypeError: # self.content is empty => title_index = None
				logging.info('display failed')
				time.sleep(0)
			else:
				logging.info('display success')
				self._export_link(self.pages[page_index].get_link(title_index))
				time.sleep(20)
			finally:
				page_index, title_index = self._get_random_index()

	def _export_link(self, link):
		"""
		Export link of current title displayed
		on polybar to $(pwd)/news_url file
		"""

		with open(self.url_file, 'w') as file:
			file.write(link)

	def start(self):
		""" Start endless loop of scraping and displaying news """

		update = Thread(target=lambda: self.update_news())
		display = Thread(target=lambda: self.display_news())

		update.start()

		# Only display if there is at least one page fetch successfully
		# because display thread will keep dicing for another page if
		# the last one is not successful
		logging.info('update.start()')
		while not self._is_content_avail():
			logging.info('content not available')
			time.sleep(3)
		logging.info('display.start()')
		display.start()

		update.join()
		display.join()

def main():
	""" main function """

	parser = argparse.ArgumentParser(description='Show headlines from various websites on polybar')
	parser.add_argument('log', nargs='?', help='Logging for debug or not')
	arg = parser.parse_args()

	pages = [
			Daa(),
			BeamNG(),
			Cosmoteer(),
			Mythologic(),
			ProjectZomboid(),
			RedditRimWorld(),
			RedditUnixporn(),
			RedditVim(),
			RedditWebdev(),
			HackerNoon(),
			Freecodecamp()
			]

	if arg.log == 'debug':
		# Shut up the request module logger
		logging.getLogger("requests").setLevel(logging.WARNING)
		logging.getLogger("urllib3").setLevel(logging.WARNING)
		# Setup logging
		logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.DEBUG)

		news = News(pages)
		# news.start()

		test_index = 5
		news.pages[test_index].update()
		news.pages[test_index].display_all()

		print()
		for i in range(0, len(news.pages[test_index].content)):
			news.pages[test_index].display(i)
			print(news.pages[test_index].get_link(i))
	else:
		news = News(pages)
		news.start()

if __name__ == '__main__':
	main()

# vim: nofoldenable
