#!/bin/env python

"""
News module for polybar that fetch news title
from various websites and put them on polybar
"""

from copy import deepcopy
import random
import time
import os
from pprint import pprint as p
from threading import Thread

import yaml
import requests
from bs4 import BeautifulSoup as soup

def color_string(string, color_envron_var):
	"""
	Print output in color in polybar format, second argument
	is environment variable from $HOME/themes/current_theme
	"""

	# Environment variables in $HOME/bin/export
	color_begin = '%{F' + os.environ[color_envron_var] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

class News(object):
	"""
	Store headlines from various websites, print it and update content
	periodically
	"""

	def __init__(self, data):
		"""
		Assign data to self.cache
		self.cache: is a dictionary which store info about a specific
		webpage to extract title later using self.display()
		self.index: element with this index is updated next
		self.max_len: max len of content displayed on polybar, otherwise, trim
		"""
		self.cache = data
		self.index = -1
		self.max_len = 75

	def __get_current_index(self):
		"""
		Get current index for cache list to update the
		webpage content to avoid updating all webpages at once
		"""

		self.index += 1
		if self.index > len(self.cache) - 1:
			self.index = 0
		return self.index

	def is_content_avail(self):
		""" return True if there is content in one of the pages """

		for page in self.cache:
			if not page['title']:
				return True
		return False

	def __get_title_url(self, url, href, href_offset=''):
		""" Get title url
		Example:
			url: 'https://www.reddit.com/r/RimWorld/new/'
			href: '/r/RimWorld/comments/7d7lrp/hexagon_20/'
			href_offset: '/r/RimWorld/new/'
			return: 'https://www.reddit.com/r/RimWorld/comments/7d7lrp/hexagon_20/'
		"""
		url = url.strip('/')
		href_offset = href_offset.strip('/')

		url = url.replace(href_offset, '').strip('/')

		return url + '/' + href

	def __export_link(self, link):
		""" Export link of current title displayed on polybar
		to $(pwd)/news_url file
		"""

		# dirname = os.path.dirname(os.path.realpath(__file__))
		dirname = '/home/near/.config/polybar/news/'
		link_file = os.path.join(dirname, 'news_url')

		with open(link_file, 'w') as file:
			file.write(link)

	def update_all(self):
		""" Update all. use for debugging """

		for index, page in enumerate(self.cache):
			print('fetch...')

			try:
				html = requests.get(page['url'], headers={'User-agent': 'news'}).text
				soup_html = soup(html, 'html.parser')
				elem_list = soup_html.select(page['selector'])

				for elem in elem_list:
					title = elem.text.strip()
					href = elem['href']
					self.cache[index]['title'].append({'name': title, 'href': href})
			except Exception as e:
				print(e)
				# print('Bad connection')

		return 0 if self.is_content_avail() else 1

	def update(self):
		""" Fetch titles periodically from the web and store it in self.cache
		only one site at a time
		"""

		index = self.__get_current_index()
		# print('update...')

		try:
			html = requests.get(self.cache[index]['url'], headers={'User-agent': 'news'}).text
			soup_html = soup(html, 'html.parser')
			elem_list = soup_html.select(self.cache[index]['selector'])

			for elem in elem_list:
				title = elem.text.strip()
				href = elem['href']
				self.cache[index]['title'].append({'name': title, 'href': href})
			# print('update successfully!')
			return 0
		except Exception as e:
			print(e)
			return 1

	def __trim_content(self, data):
		""" Trim the content if it's too long """

		name_len = len(data['name'])
		short_name_len = len(data['short_name'])
		title_len = len(data['title']['name'])

		if name_len + title_len > self.max_len:
			if short_name_len + title_len > self.max_len:
				# 2 is the len of the seperator between name and title (: )
				offset = self.max_len - (short_name_len + title_len + 2)

				data['title']['name'] = data['title']['name'][:offset-3] + '...'
		return data

	def __get_random_content(self):
		""" Get random content of the webpage and its related info """
		rand_index = random.randint(0, len(self.cache) - 1)

		if not self.cache[rand_index]['title']:
			# print('title is empty. Nothing to print')
			return None

		data = deepcopy(self.cache[rand_index])

		rand_title_index = random.randint(0, len(self.cache[rand_index]['title']) - 1)
		data['title'] = self.cache[rand_index]['title'][rand_title_index]

		data = self.__trim_content(data)

		return data

	def display(self):
		""" Print out titles from the web randomly """

		data = self.__get_random_content()

		if data is None:
			# print('title is empty. Nothing to print')
			return 1

		title_link = self.__get_title_url(data['url'], data['title']['href'], data['href_offset'])
		self.__export_link(title_link)

		print('{} {}: {}'.format(data['icon'], data['name'], data['title']['name']), flush=True)
		return 0

	def display_all(self):
		""" Debug """
		p(self.cache)

def get_data():
	"""
	Get yaml file that store data - a list of webpages info used to fetch titles on the internet
	every element is a dictionary with additional keywords:
		'name': short name of the website to put on polybar along with title like
			<website_name>: <website_title>
		'url': url of the page to get the info
		'href_offset': see News.__get_title_url() doctring
		'selector': 'a string of css selector to get the text from'
		'title': list of string titles inside the inspected elements to put on polybar
		'last_time': max time (day) since the first time it get the data to display
	"""
	# dirname = os.path.dirname(os.path.realpath(__file__))
	dirname = '/home/near/.config/polybar/news/'
	data_file = os.path.join(dirname, 'data.yaml')

	with open(data_file, 'r') as file:
		data = yaml.load(file)

	return data

def update_news(news):
	"""
	Update news periodically, endless loop,
	use in parellel with display_news
	"""
	while True:
		while news.update() != 0:
			time.sleep(2)
			news.update()
		time.sleep(30)

def display_news(news):
	"""
	Display news periodically, endless loop,
	use in parellel with update_news
	"""
	while True:
		while news.display() != 0:
			time.sleep(0)
			news.display()
		time.sleep(20)


def main():
	""" main function """

	data = get_data()
	news = News(data)

	update = Thread(target=lambda: update_news(news))
	display = Thread(target=lambda: display_news(news))

	update.start()

	# Only display if there is at least one page fetch successfully
	# because display thread will keep dicing for another page if
	# the last one is not successful
	while not news.is_content_avail():
		time.sleep(3)
	display.start()

	update.join()
	display.join()

	# news.update_all()
	# news.display_all()

# main()

# Renmind me to:
# restore __file__ variable (2)
# uncomment main func

# vim: nofoldenable
