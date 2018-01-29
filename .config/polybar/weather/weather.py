#!/bin/env python

""" Module to display weather info on polybar """

# -*- coding: utf-8 -*-

import argparse
import datetime
import logging
import os
import time
import requests
import importlib

# pylint: disable=redefined-builtin
from requests import ConnectionError
from requests.exceptions import HTTPError, Timeout

from util import color_polybar, color_bash as cb

class MyInternetIsShitty(Exception):
	""" Custom exception """
	pass

def get_args():
	""" Get script argument """
	parser = argparse.ArgumentParser(description='Show current weather on polybar')
	parser.add_argument('log', nargs='?', help='Logging for debugging or not')
	parser.add_argument('-u', '--unit', default='metric', nargs='?',
			help='unit: metric or imperial. Default: metric')
	return parser.parse_args()

def set_up_logging():
	""" Set some logging parameter """
	if importlib.util.find_spec('requests'):
		# Shut up the request module logger
		logging.getLogger("requests").setLevel(logging.WARNING)
		logging.getLogger("urllib3").setLevel(logging.WARNING)
	logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.DEBUG)


def get_day_or_night():
	""" return 'day' or 'night' based on current hour """

	hour = int(datetime.datetime.now().strftime('%H'))

	if hour >= 18 or hour <= 5:
		return 'night'

	return 'day'


def get_weather_icon(weather_id):
	""" Get weather icon based on weather condition """

	day_night_status = get_day_or_night()

	weather = {
			'thunderstorm':   200 <= weather_id <= 232,
			'rain':           300 <= weather_id <= 531,
			'snow':           600 <= weather_id <= 622,
			'atmosphere':     701 <= weather_id <= 781,
			'squall':         weather_id == 771,
			'tornado':        weather_id == 781 or weather_id == 900,
			'clear_day':      weather_id == 800 and day_night_status == 'day',
			'clear_night':    weather_id == 800 and day_night_status == 'night',
			'tropical storm': weather_id == 901,
			'hurricane':      weather_id == 902,
			'cold':           weather_id == 903,
			'hot':            weather_id == 904,
			'windy':          weather_id == 905,
			'cloudy':         801 <= weather_id <= 804,
			'hail':           weather_id == 906
			}

	if weather['thunderstorm']:
		return ''
	elif weather['rain']:
		return ''
	elif weather['snow'] or weather['cold']:
		return ''
	elif weather['atmosphere'] or weather['windy']:
		return ''
	elif (weather['squall'] or
			weather['tornado'] or
			weather['tropical storm'] or
			weather['hurricane']):
		return ''
	elif weather['clear_day'] or weather['hot']:
		return ''
	elif weather['clear_night']:
		return ''
	elif weather['cloudy']:
		return ''
	elif weather['hail']:
		return ''

def get_thermo_icon(temp_value, temp_unit):
	""" Get thermometer icon based on temperature """

	if temp_unit == 'F':
		temp_value = convert_temp_unit(temp_unit, 'C')

	if temp_value <= -15:
		return ''
	elif -15 < temp_value <= 0:
		return ''
	elif 0 < temp_value <= 15:
		return ''
	elif 15 < temp_value <= 30:
		return ''
	elif temp_value > 30:
		return ''

def convert_temp_unit(temp_value, temp_unit):
	""" Convert current temp_value to temp_unit """

	if temp_unit == 'C':
		return round((temp_value - 32) / 1.8)
	elif temp_unit == 'F':
		return round(temp_value * 1.8 + 32)

def get_api_key():
	""" Get secret api key from a file on filesystem """
	paren_dir = os.path.dirname(os.path.realpath(__file__))
	api_path = os.path.join(paren_dir, 'weather_api.txt')

	with open(api_path, 'r') as file:
		api_key = file.read().replace('\n', '')
	return api_key

def get_city_id():
	""" Workaround to get city id based on my schedule """
	region_code = {
			'TPHCM': 1580578,
			'TPHCM2': 1566083,
			'Hai Duong': 1581326,
			'Tan An': 1567069
			}

	hour = int(datetime.datetime.now().strftime('%H'))
	weekday = datetime.datetime.now().strftime('%a')

	# 5pm Fri to 5pm Sun: Tan An, else Hai Duong
	if (hour >= 17 and weekday == 'Fri') or weekday == 'Sat' or (hour < 17 and weekday == 'Sun'):
		return region_code['Tan An']
	return region_code['Hai Duong']

def update_weather(city_id, units, api_key):
	""" Update weather by using openweather api """

	url = 'http://api.openweathermap.org/data/2.5/weather?id={}&appid={}&units={}'
	temp_unit = 'C' if units == 'metric' else 'K'
	error_icon = color_polybar('', 'red')

	try:
		req = requests.get(url.format(city_id, api_key, units))

		try:
			description = req.json()['weather'][0]['description'].capitalize()
		except ValueError:
			print(error_icon, flush=True)
			raise MyInternetIsShitty

		temp_value = round(req.json()['main']['temp'])
		temp = str(temp_value) + '°' + temp_unit
		thermo_icon = color_polybar(get_thermo_icon(temp_value, units), 'main')

		weather_id = req.json()['weather'][0]['id']
		weather_icon = color_polybar(get_weather_icon(weather_id), 'main')

		print('{} {} {} {}'.format(weather_icon, description, thermo_icon, temp), flush=True)
	except (HTTPError, Timeout, ConnectionError):
		print(error_icon, flush=True)
		raise MyInternetIsShitty

def main():
	""" main function """

	arg = get_args()
	if arg.log == 'debug':
		set_up_logging()

	units = arg.unit
	api_key = get_api_key()
	city_id = get_city_id()

	while True:
		try:
			update_weather(city_id, units, api_key)
		except MyInternetIsShitty:
			logging.info(cb('update failed: ', 'red'))
			time.sleep(3)
		else:
			logging.info(cb('update success', 'green'))
			time.sleep(700)

if __name__ == '__main__':
	main()

# vim: nofoldenable
