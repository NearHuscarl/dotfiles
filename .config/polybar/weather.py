#!/bin/env python

# -*- coding: utf-8 -*-

import datetime
import os
import requests
import sys

def get_weather_icon(weather_id):
	""" Get weather icon based on weather condition """

	hour = int(datetime.datetime.now().strftime('%H'))

	if hour >= 18 or hour <= 5:
		time = 'night'
	else:
		time = 'day'

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

def get_thermo_icon(temp_value):
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

def color_string(string):
	""" Print output in color in polybar format """

	# Environment variables in $HOME/bin/export
	color_begin = '%{F' + os.environ['THEME_HL'] +  '}'
	color_end = '%{F-}'
	return color_begin + string + color_end

home_dir = os.environ['HOME']
api_path = os.path.join(home_dir, '.config/polybar/weather_api.txt')

with open(api_path, 'r') as file:
	api_key = file.read().replace('\n', '')

city_id = '1587923'
units = 'metric' if sys.argv[1] == 'metric' else 'imperial'
temp_unit = 'C' if units == 'metric' else 'K'

url = 'http://api.openweathermap.org/data/2.5/weather?id={}&appid={}&units={}'
req = requests.get(url.format(city_id, api_key, units))

try:
	if req.status_code == 200:
		description = req.json()['weather'][0]['description'].capitalize()

		temp_value = round(req.json()['main']['temp'])
		temp = str(temp_value) + '°' + temp_unit
		thermo_icon = color_string(get_thermo_icon(temp_value))

		weather_id = req.json()['weather'][0]['id']
		weather_icon = color_string(get_weather_icon(weather_id))

		print('{} {} {} {}'.format(weather_icon, description, thermo_icon, temp))
	else:
		print('Error ' + str(req.status_code))
except(ValueError, OSError):
	print('Error: Unable print the data')
