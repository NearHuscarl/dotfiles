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
from util import color_bash as cb

class News(object):
	""" Store a list a Page, update and print in periodically """

	def __init__(self, pages):
		dirname = os.path.dirname(os.path.realpath(__file__))
		self.url_file = os.path.join(dirname, 'news_url')
		self.pages = pages
		self.size = len(self.pages)
		self.index = -1

	def __repr__(self):
		return '{}({})'.format(self.__class__.__name__, self.pages)

	def _get_sum_of_titles(self):
		""" Get total number of titles from self.pages list """
		sum_ = 0
		for index in range(0, self.size):
			sum_ += len(self.pages[index])
		return sum_

	def _get_chance(self, page):
		"""
		return chance for a Page to print out one of its titles
		the more titles a page has, the more chance that page will have titles printed
		"""
		return len(page) * 100 / self._get_sum_of_titles()

	def _get_index(self):
		"""
		Get current index of pages list to update the
		webpage content to avoid updating all webpages at once
		"""

		self.index += 1
		if self.index > self.size - 1:
			self.index = 0
		return self.index

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
		chance = self._get_chance(self.pages[page_index])
		while random.randint(1, 100) > chance:
			page_index = random.randint(0, self.size - 1)
			chance = self._get_chance(self.pages[page_index])

		# Throw error if title list len is zero
		err_msg = '{}\'s title selector not available'.format(self.pages[page_index].name)
		assert 'title' in self.pages[page_index].selector, err_msg

		try:
			title_index = random.randint(0, len(self.pages[page_index].content) - 1)
		except ValueError: # self.content is empty list => random.randint(0, -1)
			return page_index, None

		return page_index, title_index

	def update_all(self):
		""" Update all pages in self.pages list once (dont update againt if failed) """
		logging.info(cb('[update all] starting...', 'magenta'))
		for index in range(self.size):
			logging.info(cb('[update all] update ', 'magenta') + cb(self.pages[index].name, 'green'))
			self.pages[index].update()
		logging.info(cb('[update all] finished', 'green'))

	def update_news(self):
		"""
		Update news periodically, endless loop,
		use in parellel with display_news
		"""

		self.update_all()

		index = self._get_index()
		while True:
			try:
				self.pages[index].update()
			except (HTTPError, Timeout, ConnectionError):
				logging.info(cb('update failed: ', 'red'))
				time.sleep(2)
			else:
				logging.info(cb('update success', 'green'))
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
				logging.info(cb('display failed', 'red'))
				time.sleep(0)
			else:
				logging.info(cb('display success', 'green'))
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
		logging.info(cb('update.start()', 'blue'))

		# Only display if there is at least one page fetch successfully
		# because display thread will keep dicing for another page if
		# the last one is not successful
		while not self._is_content_avail():
			logging.info(cb('content not available', 'red'))
			time.sleep(3)
		display.start()
		logging.info(cb('display.start()', 'blue'))

		update.join()
		display.join()

def main():
	""" main function """

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

	news = News(pages)
	news.start()

if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='Show headlines from various websites on polybar')
	parser.add_argument('log', nargs='?', help='Logging for debug or not')
	arg = parser.parse_args()

	if arg.log != 'debug':
		main()
	else:
		page_list = [
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

		# Shut up the request module logger
		logging.getLogger("requests").setLevel(logging.WARNING)
		logging.getLogger("urllib3").setLevel(logging.WARNING)
		# Setup logging
		logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.DEBUG)

		news = News(page_list)
		news.start()
		# news.update_all()

		total_list = [0] * news.size
		for i in range(0, 200):
			page_index, _ = news._get_random_index()
			total_list[page_index] += 1
			print(page_index)

		for i in range(0, news.size):
			print('\n' + news.pages[i].name + '\' title count: ' + str(len(news.pages[i])))
		print(str(total_list))

		# print(news)
		# test_index = 5
		# news.pages[test_index].update()
		# news.pages[test_index].display_all()

		# print()
		# for i in range(0, len(news.pages[test_index].content)):
		# 	news.pages[test_index].display(i)
		# 	print(news.pages[test_index].get_link(i))

# vim: nofoldenable
