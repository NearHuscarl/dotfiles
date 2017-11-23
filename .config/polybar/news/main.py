#!/bin/env python

"""
"""

import argparse
import logging
import os
import pprint
import random
import time
from threading import Thread

from requests import ConnectionError
from requests.exceptions import HTTPError, Timeout
from page import (
		Daa,
		Mythologic,
		QuoraComputerProgramming,
		Reddit,
		RedditRimWorld,
		RedditVim,
		)

class News(object):
	""" Store a list a Page, update and print in parellel periodically """

	def __init__(self, pages):
		dirname = os.path.dirname(os.path.realpath(__file__))
		self.url_file = os.path.join(dirname, 'news_url')
		self.pages = pages
		self.size = len(self.pages)
		self.index = -1
		self.index_list = random.sample(range(0, self.size), self.size)

	def __get_index(self):
		"""
		Get current index for pages list to update the
		webpage content to avoid updating all webpages at once
		"""

		self.index += 1
		if self.index > self.size - 1:
			self.index = 0
		return self.index_list[self.index]

	def __is_content_avail(self):
		""" return True if there is content in one of the pages """

		for page in self.pages:
			if 'title' in page.content:
				return True
		return False

	def __get_random_index(self):
		"""
		Return a tuple of random indexes for Page and Page.content['title'] which does 2 things:
			Get a random page
			Get a random title in that page
		"""
		page_index = random.randint(0, self.size - 1)

		# Throw error if title list len is zero
		err_msg = '{}\'s title selector not available'.format(self.pages[page_index].name['long'])
		assert 'title' in self.pages[page_index].selector, err_msg

		try:
			title_index = random.randint(0, len(self.pages[page_index].content['title']) - 1)
		except KeyError:
			return page_index, None

		return page_index, title_index


	def update_news(self):
		"""
		Update news periodically, endless loop,
		use in parellel with display_news
		"""

		index = self.__get_index()

		while True:
			try:
				self.pages[index].update()
			except (HTTPError, Timeout, ConnectionError):
				logging.info('update failed: ')
				time.sleep(2)
			else:
				logging.info('update success')
				time.sleep(3)
			finally:
				index = self.__get_index()

	def display_news(self):
		"""
		Display news periodically, endless loop,
		use in parellel with update_news
		"""

		page_index, title_index = self.__get_random_index()

		while True:
			try:
				self.pages[page_index].display(title_index)
			except KeyError:
				logging.info('display failed')
				time.sleep(0)
			else:
				logging.info('display success')
				self.__export_link(self.pages[page_index].get_link(title_index))
				time.sleep(2)
			finally:
				page_index, title_index = self.__get_random_index()

	def __export_link(self, link):
		""" Export link of current title displayed on polybar
		to $(pwd)/news_url file
		"""

		with open(self.url_file, 'w') as file:
			file.write(link)

	def start(self):
		""" Start endless loop of scraping and display news """

		update = Thread(target=lambda: self.update_news())
		display = Thread(target=lambda: self.display_news())

		update.start()

		# Only display if there is at least one page fetch successfully
		# because display thread will keep dicing for another page if
		# the last one is not successful
		logging.info('update.start()')
		while not self.__is_content_avail():
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
			Mythologic(),
			QuoraComputerProgramming(),
			RedditRimWorld(),
			RedditVim()
			]

	arg.log = 'debug'

	if arg.log == 'debug':
		# Shut up the request module logger
		logging.getLogger("requests").setLevel(logging.WARNING)
		logging.getLogger("urllib3").setLevel(logging.WARNING)
		# Setup logging
		logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.DEBUG)

		news = News(pages)
		news.start()
		# news.pages[2].update()
		# news.pages[2].display_all()
		# news.pages[2].display(0)
		# print(news.pages[2].get_link(0))

		# print()
		# for i in range(0, len(news.pages[0].content['title'])):
		# 	news.pages[0].display(i)
	else:
		news = News(pages)
		news.start()

if __name__ == '__main__':
	main()

# vim: nofoldenable
