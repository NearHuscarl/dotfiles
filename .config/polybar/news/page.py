#!/bin/env python

"""
News module for polybar that fetch news title
from various websites and put them on polybar
"""

import logging
import os
import pprint
from datetime import datetime

import requests
from requests.exceptions import HTTPError, Timeout
from bs4 import BeautifulSoup as soup

max_len = 75

def color_string(string, color_envron_var):
	"""
	Print output in color in polybar format, second argument
	is environment variable from $HOME/themes/current_theme
	"""

	# Environment variables in $HOME/bin/export
	color_begin = '%{F' + os.environ[color_envron_var] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

class Page(object):
	"""
	Interface to implement subclass that hold the info
	in order to scrap the titles on the internet
	"""
	def __init__(self):
		"""
		List of attributes that will be defined in subclass
		content_selector: string of inner container html tag that hold
			title, author name, link... Represent a headline and its relevant info
		"""
		self.name = {'long': '', 'short': ''}
		self.url = {'base': ''}
		self.selector = {}
		self.content = {}
		self.icon = ''
		self.interval = 0

	def __trim_content(self, title):
		""" Trim the content if it's too long """

		name_len = len(self.name['long'])
		short_name_len = len(self.name['short'])
		title_len = len(title)

		if name_len + title_len > max_len:
			if short_name_len + title_len > max_len:
				# 2 is the len of the seperator between name and title (: )
				offset = max_len - (short_name_len + title_len + 2)

				if title[offset-3] == ' ':
					title = title[:offset-3] + '...'
				else:
					title = title[:offset-3].rsplit(' ', 1)[0] + '...'

		return title

	def get_link(self, index):
		""" Get title url of specific title using index parameter """

		# logging.info('Retrieve link for title')
		# logging.info('Reimplement in subclass if neccessary')

		url = self.url['base'].strip('/')

		try:
			href = self.content['title'][index]['href'].strip('/')
		except KeyError:
			return ''

		return url + '/' + href

	def __filter(self):
		""" Filter invalid titles (Too old or not enough upvotes...) """

		# logging.info('Filter invalid titles (Too old or not enough upvotes...)')
		# logging.info('Implement in subclass')

		return True

	def update(self):
		""" Update self.content dictionary using self.selector dictionary """

		logging.info('update ' + self.name['long'] + "'s content")

		try:
			assert 'title' in self.selector, 'no "title" key self.selector Mythologic class'

			if 'working' in self.url:
				html = requests.get(self.url['working'], headers={'User-agent': 'news'}).text
			else:
				html = requests.get(self.url['base'], headers={'User-agent': 'news'}).text

			soup_html = soup(html, 'html.parser')

			for selector_name, selector_val in self.selector.items():
				element = soup_html.select(selector_val)

				if not self.__filter():
					continue
				self.content[selector_name] = element

			# Raise error if one of the key value dont have the same len as the rest
			first_name = list(self.content.keys())[0]
			first_len = len(self.content[first_name])

			for selector_name in list(self.selector.keys())[1:]:
				check = len(self.content[first_name]) == len(self.content[selector_name])
				err_msg = "self.content[{}] ({}) and self.content[{}]'s ({}) len is not equal"
				current_len = len(self.content[selector_name])

				assert check, err_msg.format(first_name, first_len, selector_name, current_len)

			return 0
		except (HTTPError, Timeout, requests.ConnectionError) as error:
			print(error)
			return 1

	def display(self, index):
		""" Print out titles from the web based on index parameter """

		icon = color_string(self.icon, 'THEME_MAIN')

		try:
			title = self.__trim_content(self.content['title'][index].text.strip())
		except KeyError:
			return 1

		if len(self.name['long']) + len(title) <= max_len:
			name = self.name['long']
		else:
			name = self.name['short']

		print('{} {}: {}'.format(icon, name, title), flush=True)
		return 0

	def display_all(self):
		""" Display all data, use for debugging """

		pprint.pprint('self.name:             ' + str(self.name))
		pprint.pprint('self.url               ' + str(self.url))
		pprint.pprint('self.selector:       \n' + pprint.pformat(str(self.selector)))
		pprint.pprint('self.content:        \n' + pprint.pformat(str(self.content)))
		pprint.pprint('self.icon:             ' + self.icon)
		pprint.pprint('self.interval:         ' + str(self.interval))

class Mythologic(Page):
	""" Implementation of mythologicinteractive.com Page """

	def __init__(self):
		super().__init__()
		self.name = {
				'long': 'mythologicinteractive',
				'short': 'SFD'
				}
		self.url['base'] = 'http://mythologicinteractive.com/'
		self.selector = {
				'title': 'a[href*=Blog/]',
				'date': 'span.blogCreateDate'
				}
		self.icon = ''
		self.interval = 20

class Daa(Page):
	""" Implementation of daa.uit.edu.vn Page """

	def __init__(self):
		super().__init__()
		self.name = {
				'long': 'Thông báo uit',
				'short': 'daa'
				}
		self.url['base'] = 'https://daa.uit.edu.vn/'
		self.selector = {
				'title': '.view-hien-thi-bai-viet-moi a[href*=thongbao]',
				'date': '.view-hien-thi-bai-viet-moi li'
				}
		self.icon = ''
		self.interval = 5

class Quora(Page):
	""" Implementation of daa.uit.edu.vn Page """

	def __init__(self):
		super().__init__()
		self.name = {
				'long': 'Quora',
				'short': 'Quora'
				}
		self.url['base'] = 'https://www.quora.com/'
		self.selector = {
				'title': '.AnswerStoryBundle .AnswerStoryBundle a.question_link',
				'date': '.AnswerStoryBundle .AnswerStoryBundle a.answer_permalink'
				}
		self.icon = ''

	def __filter(self):
		""" Dont scrape anything, only use this class as interface """
		return False

	def get_link(self, index):
		""" Get title url of specific title using index parameter """

		url = self.url['base'].strip('/')

		try:
			href = self.content['date'][index]['href'].strip('/')
		except KeyError:
			return ''

		return url + '/' + href

class QuoraComputerProgramming(Quora):
	""" Implementation of daa.uit.edu.vn Page """

	def __init__(self):
		super().__init__()
		self.name = {
				'long': '[Q] Computer Programming',
				'short': 'Quora CP'
				}
		self.url['working'] = 'https://www.quora.com/topic/Computer-Programming/'

class Reddit(Page):
	""" Implementation of reddit.com Page """

	def __init__(self):
		super().__init__()
		self.name = {
				'long': 'Reddit',
				'short': 'Reddit'
				}
		self.url['base'] = 'https://www.reddit.com/'
		self.selector = {
				'title': '.sitetable.linklisting a[data-event-action=title]',
				'date': '.sitetable.linklisting .live-timestamp',
				'comment': '.sitetable.linklisting .bylink.comments.may-blank',
				'upvote': '.sitetable.linklisting .score.unvoted'
				}
		self.icon = ''
		self.interval = 1.5

	def get_link(self, index):
		""" Get title url
		Example with url, href:
			self.url: 'https://www.reddit.com/
			href: '/r/RimWorld/comments/7d7lrp/hexagon_20/'
			return: 'https://www.reddit.com/r/RimWorld/comments/7d7lrp/hexagon_20/'
		"""

		url = self.url['base'].strip('/')

		try:
			href = self.content['comment'][index]['comment'].strip('/')
		except KeyError:
			return ''

		return url + '/' + href

class RedditRimWorld(Reddit):
	""" Implementation of reddit.com Page """

	def __init__(self):
		super().__init__()
		self.name = {
				'long': '/r/RimWorld',
				'short': 'Rimworld'
				}
		self.url['working'] = 'https://www.reddit.com/r/RimWorld/new/'

class RedditVim(Reddit):
	""" Implementation of reddit.com Page """

	def __init__(self):
		super().__init__()
		self.name = {
				'long': '/r/vim',
				'short': 'Vim'
				}
		self.url['working'] = 'https://www.reddit.com/r/vim/new/'

# vim: nofoldenable
