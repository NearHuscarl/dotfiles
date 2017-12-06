#!/bin/env python

"""
Page module that contain a list of Page class
and its variants implemented in subclass
which can update, filter titles and display them
"""

import logging
import os
import pprint
import time
from datetime import datetime

import feedparser
import requests
from bs4 import BeautifulSoup as soup
from util import color_polybar, color_bash as cb

max_len = 75

class Page(object):
	"""
	Interface to implement subclass that hold the
	info in order to scrap the titles on the internet
	and display them
	"""
	def __init__(self):
		"""
		List of (default) attributes that will be defined or overrided in subclass:
			self.name: name of the website (reddit)
			self.url:
				self.url['working'] is used to download content and url['base']
					is used to get link
				if there is no self.url['working'], self.url['base'] will be used to
					download content instead
			self.selector: list of css selector that will be used to get relevant elements
				that hold info about title, time...
			self.content_selector: list of result elements selected from said selectors
			self.icon: prefix text to display on polybar for aesthetic purpose
			self.filter: dictionary of properties that will be used to evaluated to filter
				invalid title (too old or not enough upvote...)
				filter['interval']: max days to filter old headline
				filter['timefmt']: time format used to get parse date from date string
		"""
		self.name = ''
		self.url = {'base': ''}
		self.selector = {'title': '', 'date': ''}
		self.content = []
		self.icon = ''
		self.filter = {'interval': 0, 'timefmt': ''}

	def __repr__(self):
		return '{}()'.format(self.__class__.__name__)

	def __len__(self):
		return len(self.content)

	def _trim_content(self, headline, title):
		"""
		Trim title if headline len exceed max len
		title (part of headline): target to be trimmed off
		headline: title + other info to be displayed on polybar
		return: headline with trimmed title
		"""

		headline_len = len(headline)

		if headline_len > max_len:
			offset = max_len - headline_len

			if title[offset-3] == ' ':
				trimmed_title = title[:offset-3] + '...'
			else:
				trimmed_title = title[:offset-3].rsplit(' ', 1)[0] + '...'
			headline = headline.replace(title, trimmed_title)

		return headline

	def get_link(self, index):
		""" Get url of specific title using index parameter
		Example with url, href:
			self.url['base']: 'https://www.reddit.com/'
			href: '/r/RimWorld/comments/7d7lrp/hexagon_20/' or
				'https://www.reddit.com/r/RimWorld/comments/7d7lrp/hexagon_20/'
			return: 'https://www.reddit.com/r/RimWorld/comments/7d7lrp/hexagon_20/'
		"""

		url = self.url['base'].strip('/')
		href = self.content[index]['href'].strip('/')

		if url in href:
			return href
		return url + '/' + href

	def _filter(self):
		""" Filter invalid titles (Too old or not enough upvotes...) """

		time_now = time.mktime(datetime.now().timetuple())

		self.content = [title for title in self.content if
				time_now - title['date'] <= 3600 * 24 * self.filter['interval']]

	def _parse_time(self, soup_elem):
		"""
		Parse time. element in soup so extract text first to get the string
		implement on subclass depend on time format in
		string like '26 Nov 2017' or '26 November 2017'
		"""
		date = soup_elem.text.strip()
		return time.mktime(datetime.strptime(date, self.filter['timefmt']).timetuple())

	def update(self):
		""" Update self.content using self.selector to target the right elements """

		logging.info(cb('update ', 'yellow') + cb(self.name, 'green') + cb("'s content", 'yellow'))

		url = self.url['working'] if 'working' in self.url else self.url['base']
		page_html = requests.get(url, headers={'User-agent': 'news'}).text

		page_soup = soup(page_html, 'html.parser')

		title = page_soup.select(self.selector['title'])
		date = page_soup.select(self.selector['date'])
		assert len(title) == len(date), 'title and date len is not equal'

		for title, date in zip(title, date):
			self.content.append({
				'title': title.text.strip(),
				'href': title['href'],
				'date': self._parse_time(date)
				})

		self._filter()

	def display(self, index):
		""" Print out titles from the web based on index parameter """

		icon = color_polybar(self.icon, 'THEME_MAIN')
		name = self.name
		title = self.content[index]['title']

		headline = '{}: {}'.format(name, title)
		headline = self._trim_content(headline, title)
		print('{} {}'.format(icon, headline), flush=True)

	def display_all(self):
		""" Display all data, use for debugging """

		print('self.name:')
		pprint.pprint(self.name)
		print('\nself.url:')
		pprint.pprint(self.url)
		print('\nself.selector:')
		pprint.pprint(self.selector)
		print('\nself.content:')
		pprint.pprint(self.content)
		print('\nself.icon:')
		pprint.pprint(self.icon)
		print('\nself.filter:')
		pprint.pprint(self.filter)

class BeamNG(Page):
	""" blog.beamng.com/ Page """

	def __init__(self):
		super().__init__()
		self.name = 'BeamNG'
		self.url = {
				'base': 'http://blog.beamng.com/',
				'working': 'http://blog.beamng.com/blog/'
				}
		self.selector = {
				'title': 'article a[href*=http://blog.beamng.com/]',
				'date': 'article .date'
				}
		self.icon = ''
		self.filter = {
				'interval': 4,
				'timefmt': '%d %B %Y' # 26 November 2017
				}

class Cosmoteer(Page):
	""" https://cosmoteer.net/ Page """

	def __init__(self):
		super().__init__()
		self.name = 'Cosmoteer'
		self.url['base'] = 'http://blog.cosmoteer.net/'
		self.selector = {
				'title': '.date-outer .post-title a',
				'date': '.date-outer .date-header'
				}
		self.icon = ''
		self.filter = {
				'interval': 6,
				'timefmt': '%A, %B %d, %Y' # Tuesday, September 19, 2017
				}

class Mythologic(Page):
	""" mythologicinteractive.com Page """

	def __init__(self):
		super().__init__()
		self.name = 'Mythologic'
		self.url['base'] = 'http://mythologicinteractive.com/'
		self.selector = {
				'title': 'a[href*=Blog/]',
				'date': 'span.blogCreateDate'
				}
		self.icon = ''
		self.filter = {
				'interval': 4,
				'timefmt': 'Added %d %b %Y' # Added 26 Nov 2017
				}

class ProjectZomboid(Page):
	""" https://projectzomboid.com/blog/category/news-development/ Page """

	def __init__(self):
		super().__init__()
		self.name = 'Project Zomboid'
		self.url = {
				'base': 'https://projectzomboid.com/blog/',
				'working': 'https://projectzomboid.com/blog/category/news-development/'
				}
		self.selector = {
				'title': '.bodyContentListContainer .comictext.title a',
				'date': '.bodyContentListContainer .comictext.title .content'
				}
		self.icon = ''
		self.filter = {
				'interval': 6,
				'timefmt': '%B %d, %Y' # November 16, 2017
				}

	def _parse_time(self, soup_elem):
		""" Parse time string. Remove extra \t in text """
		date = soup_elem.contents[2].strip('\t')
		return time.mktime(datetime.strptime(date, self.filter['timefmt']).timetuple())

class Daa(Page):
	""" Subclass of Page """

	def __init__(self):
		super().__init__()
		self.name = 'Thông báo uit'
		self.url['base'] = 'https://daa.uit.edu.vn/'
		self.selector = {
				'title': '.view-hien-thi-bai-viet-moi a[href*=thongbao]',
				'date': '.view-hien-thi-bai-viet-moi li'
				}
		self.icon = ''
		self.filter = {
				'interval': 7,
				'timefmt': '%d/%m/%Y - %H:%M' # 20/09/2017 - 08:37
				}

	def _parse_time(self, soup_elem):
		""" Parse time string. remove extra characters in time string """
		date = soup_elem.contents[2].strip(' -\n')
		return time.mktime(datetime.strptime(date, self.filter['timefmt']).timetuple())

class Reddit(Page):
	""" Subclass of Page
	Use API to get timestamp directly so it dont need self.filter['timefmt'] to parse time
	"""

	def __init__(self):
		""" self.limit: max post specify in url query """
		super().__init__()
		self.name = 'Reddit'
		self.limit = 25
		self.url = {
				'base': 'https://www.reddit.com/',
				'api': 'https://www.reddit.com/.json?limit=' + str(self.limit)
				}
		self.content = []
		self.icon = ''
		self.filter = {
				'interval': 1.5,
				'upvote': 0
				}

	def get_link(self, index):
		""" Get title url
		Example with url, href:
			self.url['base]: 'https://www.reddit.com/
			href: '/r/RimWorld/comments/7d7lrp/hexagon_20/'
			return: 'https://www.reddit.com/r/RimWorld/comments/7d7lrp/hexagon_20/'
		"""

		base = self.url['base'].strip('/')
		href = self.content[index]['href'].strip('/')

		return base + '/' + href

	def _filter(self):
		""" Filter headlines that is under self.filter['upvote'] upvotes or when too old """
		min_upvote = self.filter['upvote']
		time_now = time.mktime(datetime.now().timetuple())

		self.content = [title for title in self.content if
				int(title['upvote']) >= min_upvote
				and time_now - title['date'] <= 3600 * 24 * self.filter['interval']]

	def update(self):
		""" Update reddit using API """

		logging.info(cb('update ', 'yellow') + cb(self.name, 'green') + cb("'s content", 'yellow'))

		url = self.url['api']
		page = requests.get(url, headers={'User-agent': 'news'})

		for i in range(0, self.limit):
			headline = {
					'title': page.json()['data']['children'][i]['data']['title'],
					'href': page.json()['data']['children'][i]['data']['permalink'],
					'nsfw': page.json()['data']['children'][i]['data']['over_18'],
					'upvote': str(page.json()['data']['children'][i]['data']['ups']),
					'date': page.json()['data']['children'][i]['data']['created']
					}
			self.content.append(headline)

		self._filter()

	def display(self, index):
		""" Print out titles from the web based on index parameter """

		icon = color_polybar(self.icon, 'THEME_MAIN')
		name = self.name
		nsfw = color_polybar('[NSFW] ', 'THEME_ALERT') if self.content[index]['nsfw'] else ''
		title = self.content[index]['title']
		upvote = self.content[index]['upvote']

		headline = '{}: {}{} ({})'.format(name, nsfw, title, upvote)
		headline = self._trim_content(headline, title)
		print('{} {}'.format(icon, headline), flush=True)

class RedditRimWorld(Reddit):
	""" Subclass of Reddit Page """

	def __init__(self):
		super().__init__()
		self.name = '/r/RimWorld'
		self.url['api'] = 'https://www.reddit.com/r/RimWorld/.json?limit=' + str(self.limit)
		self.filter = {
				'interval': 2,
				'upvote': 90
				}

class RedditUnixporn(Reddit):
	""" Subclass of Reddit Page """

	def __init__(self):
		super().__init__()
		self.name = '/r/unixporn'
		self.url['api'] = 'https://www.reddit.com/r/unixporn/.json?limit=' + str(self.limit)
		self.filter = {
				'interval': 3,
				'upvote': 150
				}

class RedditVim(Reddit):
	""" Subclass of Reddit Page """

	def __init__(self):
		super().__init__()
		self.name = '/r/vim'
		self.url['api'] = 'https://www.reddit.com/r/vim/.json?limit=' + str(self.limit)
		self.filter = {
				'interval': 4,
				'upvote': 10
				}

class RedditWebdev(Reddit):
	""" Subclass of Reddit Page """

	def __init__(self):
		super().__init__()
		self.name = '/r/webdev'
		self.url['api'] = 'https://www.reddit.com/r/webdev/.json?limit=' + str(self.limit)
		self.filter = {
				'interval': 2,
				'upvote': 300
				}

class Medium(Page):
	""" Subclass of Page """
	def __init__(self):
		super().__init__()
		self.name = 'Medium'
		self.url = {
				'base': 'https://medium.com/',
				'feed': 'https://medium.com/feed/topic/technology'
				}
		self.content = []
		self.icon = ''
		self.filter['interval'] = 2

	def update(self):
		""" Subclass of Page. Use rss feed to update content """

		logging.info(cb('update ', 'yellow') + cb(self.name, 'green') + cb("'s content", 'yellow'))

		# pylint: disable=no-member
		feed = feedparser.parse(self.url['feed'])

		for i in range(0, len(feed.entries)):
			headline = {
					'title': feed.entries[i].title,
					'link': feed.entries[i].link,
					'date': time.mktime(feed.entries[i].published_parsed)
					}
			self.content.append(headline)

		self._filter()

	def display(self, index):
		""" Print out titles from the web based on index parameter """

		icon = color_polybar(self.icon, 'THEME_MAIN')
		name = self.name
		title = self.content[index]['title']

		headline = '{}: {}'.format(name, title)
		headline = self._trim_content(headline, title)
		print('{} {}'.format(icon, headline), flush=True)

	def get_link(self, index):
		return self.content[index]['link']

class HackerNoon(Medium):
	""" Subclass of Medium """
	def __init__(self):
		super().__init__()
		self.name = 'Hackernoon'
		self.url['feed'] = 'https://hackernoon.com/feed/'
		self.content = []

class Freecodecamp(Medium):
	""" Subclass of Medium """
	def __init__(self):
		super().__init__()
		self.name = 'Freecodecamp'
		self.url['feed'] = 'https://medium.freecodecamp.org/feed/'
		self.content = []
