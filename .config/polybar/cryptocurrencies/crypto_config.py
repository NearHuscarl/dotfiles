#!/usr/bin/env python3

"""
Update crypto statistics to config file using coinmarketcap API
Use currency.converter() if currency to convert to not supported,
which use another API that is limited by 100 calls/hour
"""

import time

import requests

import currency
from config import get_config_path, read_config, write_config

supported_currencies = ['AUD', 'BRL', 'CAD', 'CHF', 'CLP', 'CNY', 'CZK', 'DKK', 'EUR',
'GBP', 'HKD', 'HUF', 'IDR', 'ILS', 'INR', 'JPY', 'KRW', 'MXN', 'MYR', 'NOK', 'NZD',
'PHP', 'PKR', 'PLN', 'RUB', 'SEK', 'SGD', 'THB', 'TRY', 'TWD', 'ZAR', 'VND']

config_path = get_config_path()
config = read_config(config_path)
coinnames = [x for x in config.sections() if x != 'general']

def get_option(base_currency):
	""" return a dict of currency to convert to for params argument in request.get()
	empty dict if currency is not support in API """
	if base_currency in supported_currencies: # if coinmarketcap API support convert to currency
		return {'convert': base_currency}
	return {}

def check_update():
	""" check if last update is over 3 mins ago. if so return True to update, else False """
	# if never updated before
	config['general'].setdefault('last_update', '0')
	last_update = float(config['general']['last_update'])
	if time.time() - last_update >= 200: # if last update is more than 3 min ago
		return True
	for crypto in coinnames: # update if detect newly add section
		if not config.has_option(crypto, 'symbol'):
			return True
	return False

def get_crypto_info(tracked_coins):
	""" get info about cryptos list in config file
	return value: a dictionary with key is crypto id and value is a dict of its attributes """

	api_url = 'https://api.coinmarketcap.com/v1/ticker/'
	base_currency = config['general']['base_currency']
	option_dict = get_option(base_currency)
	cryptocurrencies = requests.get(api_url, params=option_dict).json()

	data = {}
	local_price_str = 'price_' + base_currency.lower()
	for crypto in cryptocurrencies:
		if crypto['id'] in tracked_coins:
			coinname = crypto['id']
			data[coinname] = crypto
			if base_currency not in supported_currencies + ['USD', '']:
				price_usd = float(crypto['price_usd'])
				price = currency.convert('USD', base_currency, price_usd)
				data[coinname][local_price_str] = price
	return data

def update_config():
	""" update crypto stats from coinmarketcap to config file """
	if check_update() is False:
		return
	config['general']['last_update'] = str(time.time())

	base_currency = config['general']['base_currency']
	local_price = 'price_' + base_currency.lower()

	cryptocurrencies = get_crypto_info(coinnames)
	for crypto, attr in cryptocurrencies.items():
		config[crypto] = {}
		config[crypto]['symbol'] = attr['symbol']
		config[crypto]['change_24'] = attr['percent_change_24h']
		config[crypto]['price_btc'] = str(round(float(attr['price_btc']), 3))
		config[crypto]['price_usd'] = str(round(float(attr['price_usd']), 3))
		if base_currency not in ['USD', '']:
			config[crypto][local_price] = str(round(float(attr[local_price]), 3))

	write_config(config_path, config)

if __name__ == '__main__':
	update_config()

# vim: nofoldenable
