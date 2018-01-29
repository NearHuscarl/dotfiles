#!/usr/bin/env python3

""" Cryptocurrencies module for polybar """

import configparser
import os
import sys

import requests
from util import color_polybar

config = configparser.ConfigParser()

def get_currency_to_convert_to():
	""" Return currency to convert to from cryptocurrencies """
	return config['general']['base_currency']

def get_cryptocurrencies():
	""" Return list of crypto to keep track of """
	# File must be opened with utf-8 explicitly
	dirname = os.path.dirname(os.path.realpath(__file__))
	config_path = os.path.join(dirname, 'config')
	with open(config_path, 'r') as file:
		config.read_file(file)

	# Everything except the general section
	return [x for x in config.sections() if x != 'general']

def get_change_in_24(json):
	""" Get change from 24 hour + color """
	change_24 = float(json['percent_change_24h'])
	color = 'green' if change_24 >= 0 else 'red'
	return color_polybar('{}%'.format(str(change_24)), color)

def main():
	cryptocurrencies = get_cryptocurrencies()
	base_currency = get_currency_to_convert_to()
	convert_to = {'convert': base_currency}

	for currency in cryptocurrencies:
		icon = color_polybar(config[currency]['icon'], 'main')
		api_url = 'https://api.coinmarketcap.com/v1/ticker/{}'.format(currency)
		json = requests.get(api_url, params=convert_to).json()[0]
		local_price = round(float(json['price_{}'.format(base_currency.lower())]), 2)
		change_24 = get_change_in_24(json)

		display_opt = config['general']['display']
		if display_opt == 'both' or display_opt is None:
			sys.stdout.write('{} {}/{} '.format(icon, local_price, change_24))
		elif display_opt == 'percentage':
			sys.stdout.write('{} {} '.format(icon, change_24))
		elif display_opt == 'price':
			sys.stdout.write('{} {} '.format(icon, local_price))

if __name__ == '__main__':
	main()

# vim: nofoldenable
