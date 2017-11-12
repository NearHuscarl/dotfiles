#!/bin/env python

""" Module to display weather info on polybar """

# -*- coding: utf-8 -*-

import argparse
import datetime
import os
import time
import requests

from requests import exceptions

parser = argparse.ArgumentParser(description='Display number of files in trash for polybar')
parser.add_argument('-u', '--unit', default='metric', nargs='?',
		help='unit: metric or imperial. Default: metric')
arg = parser.parse_args()

def get_time():
	""" return 'day' or 'night' based on current hour """

	hour = int(datetime.datetime.now().strftime('%H'))

	if hour >= 18 or hour <= 5:
		return 'night'

	return 'day'


def get_weather_icon(weather_id):
	""" Get weather icon based on weather condition """

	time = get_time()

	weather = {
			'thunderstorm':   200 <= weather_id <= 232,
			'rain':           300 <= weather_id <= 531,
			'snow':           600 <= weather_id <= 622,
			'atmosphere':     701 <= weather_id <= 781,
			'squall':         weather_id == 771,
			'tornado':        weather_id == 781 or weather_id == 900,
			'clear_day':      weather_id == 800 and time == 'day',
			'clear_night':    weather_id == 800 and time == 'night',
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

def color_string(string, color_envron_var):
	"""
	Print output in color in polybar format, second argument
	is environment variable from $HOME/themes/current_theme
	"""

	# Environment variables in $HOME/bin/export
	color_begin = '%{F' + os.environ[color_envron_var] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

def update_weather(city_id, units, api_key):
	""" Update weather by using openweather api """

	url = 'http://api.openweathermap.org/data/2.5/weather?id={}&appid={}&units={}'
	temp_unit = 'C' if units == 'metric' else 'K'
	error_icon = color_string('', 'THEME_ALERT')

	try:
		req = requests.get(url.format(city_id, api_key, units))

		description = req.json()['weather'][0]['description'].capitalize()

		temp_value = round(req.json()['main']['temp'])
		temp = str(temp_value) + '°' + temp_unit
		thermo_icon = color_string(get_thermo_icon(temp_value, units), 'THEME_HL')

		weather_id = req.json()['weather'][0]['id']
		weather_icon = color_string(get_weather_icon(weather_id), 'THEME_HL')

		print('{} {} {} {}'.format(weather_icon, description, thermo_icon, temp), flush=True)
		return 0
	except (exceptions.ConnectionError, exceptions.Timeout, exceptions.HTTPError):
		print(error_icon, flush=True)
		return 1

def main():
	""" main function """

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
		city_id = region_code['Tan An']
	else:
		city_id = region_code['Hai Duong']

	paren_dir = os.path.dirname(os.path.realpath(__file__))
	api_path = os.path.join(paren_dir, 'weather_api.txt')

	with open(api_path, 'r') as file:
		api_key = file.read().replace('\n', '')

	units = arg.unit
	result = update_weather(city_id, units, api_key)

	while True:
		if result == 0:
			time.sleep(700)
			result = update_weather(city_id, units, api_key)
		else:
			time.sleep(3)
			result = update_weather(city_id, units, api_key)

main()

# vim: nofoldenable
