#!/bin/env python

"""
News module for polybar that fetch news title
from various websites and put them on polybar
"""

import random
import time
import os
from pprint import pprint as p
from threading import Thread

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
		self.cache is a dictionary which store info about a specific
		webpage to extract title later using self.display()
		"""
		self.cache = data
		self.index = -1

	def __get_current_index(self):
		"""
		Get current index for cache list to update the
		current element to avoid update all webpages at once
		"""

		self.index += 1
		if self.index > len(self.cache) - 1:
			self.index = 0
		return self.index

	def is_content_avail(self):
		""" return True if there is content in one of the pages """

		for page in self.cache:
			if len(page['content']) != 0:
				return True
		return False

	def update_all(self):
		""" Update all. use for debugging """

		for index, page in enumerate(self.cache):
			print('fetch...')

			try:
				html = requests.get(page['url'], headers = {'User-agent': 'news'}).text
				soup_html = soup(html, 'html.parser')
				elem_list = soup_html.select(page['selector'])

				self.cache[index]['content'] = [elem.text.strip() for elem in elem_list]
			except Exception as e:
				print(e)
				print('Bad connection')

		return 0 if self.is_content_avail() else 1

	def update(self):
		""" Fetch titles periodically from the web and store it in self.cache
		only one site at a time
		"""

		index = self.__get_current_index()
		# print('update...')

		try:
			html = requests.get(self.cache[index]['url'], headers = {'User-agent': 'news'}).text
			soup_html = soup(html, 'html.parser')
			elem_list = soup_html.select(self.cache[index]['selector'])

			self.cache[index]['content'] = [elem.text.strip() for elem in elem_list]
			# print('update successfully!')
			return 0
		except Exception as e:
			print(e)
			return 1

	def display(self):
		""" Print out titles from the web randomly """

		rand_index = random.randint(0, len(self.cache) - 1)

		if len(self.cache[rand_index]['content']) == 0:
			# print('content is empty. Nothing to print')
			return 1

		rand_content_index = random.randint(0, len(self.cache[rand_index]['content']) - 1)
	
		name = self.cache[rand_index]['name']
		icon = color_string(self.cache[rand_index]['icon'], 'THEME_MAIN')
		title = self.cache[rand_index]['content'][rand_content_index]
		print('{} {}: {}'.format(icon, name, title), flush=True)
		return 0

	def display_all(self):
		""" Debug """
		p(self.cache)

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

	"""
	data is a list of webpage info use to fetch titles on the internet
	every element is a dictionary with additional keywords:
		'name': short name of the website to put on polybar along with content like
			<website_name>: <website_title>
		'url': url of the page to get the info
		'selector': 'a string of css selector to get the text from'
		'content': list of string titles inside the inspected elements to put on polybar
		'last_time': max time (day) since the first time it get the data to display
	"""
	data = [
			{
				'name': 'mythologicinteractive',
				'url': 'http://mythologicinteractive.com/',
				'selector': 'a[href*=Blog/]',
				'content': [],
				'icon': '',
				'format': '',
				'last_time': 20
				},
			{
				'name': '/r/RimWorld',
				'url': 'https://www.reddit.com/r/RimWorld/new',
				'selector': 'a[data-event-action=title]',
				'content': [],
				'icon': '',
				'format': '',
				'last_time': 1.5
				},
			{
				'name': 'daa',
				'url': 'https://daa.uit.edu.vn/',
				'selector': 'div.view-hien-thi-bai-viet-moi a[href*=thongbao]',
				'content': [],
				'icon': '',
				'format': '',
				'last_time': 5
				}
			]

	news = News(data)

	# update = Thread(target=lambda: update_news(news))
	# display = Thread(target=lambda: display_news(news))

	# update.start()

	# # Only display if there is at least one page fetch successfully
	# # because display thread will keep dicing for another page if
	# # the last one is not successful
	# while not news.is_content_avail():
	# 	time.sleep(3)
	# display.start()

	news.update_all()
	news.display_all()

main()

# vim: nofoldenable
