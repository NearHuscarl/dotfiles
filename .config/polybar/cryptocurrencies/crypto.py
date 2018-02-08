#!/usr/bin/env python3

"""
Update crypto statistics to cache file using coinmarketcap API
Use currency.converter() if currency to convert to not supported,
"""

import requests

import currency
from config import get_config_path, read_config
from cache import get_cache_path, write_cache

supported_currencies = ['AUD', 'BRL', 'CAD', 'CHF', 'CLP', 'CNY', 'CZK', 'DKK', 'EUR',
'GBP', 'HKD', 'HUF', 'IDR', 'ILS', 'INR', 'JPY', 'KRW', 'MXN', 'MYR', 'NOK', 'NZD',
'PHP', 'PKR', 'PLN', 'RUB', 'SEK', 'SGD', 'THB', 'TRY', 'TWD', 'ZAR', 'VND']

config_path = get_config_path()
config = read_config(config_path)

def get_currency_to_convert_to(base_currency):
	""" return a dict of currency to convert to for params argument in request.get()
	empty dict if currency is not support in API """
	if base_currency in supported_currencies: # if coinmarketcap API support convert to currency
		return {'convert': base_currency}
	return {}

def process_meta_info(meta):
	""" pretty price number in meta """
	volume_24h = int(meta['total_24h_volume_usd'])
	market_cap = int(meta['total_market_cap_usd'])
	meta['total_24h_volume_usd'] = currency.pretty(volume_24h, 'USD')
	meta['total_market_cap_usd'] = currency.pretty(market_cap, 'USD')
	return meta

def process_crypto_info(crypto):
	""" convert to local currency if specified in config file
	trim long decimals and format price number. then save into cache file """

	base_currency = config['general']['base_currency'].lower()
	local_price_str = 'price_' + base_currency

	price_btc = float(crypto['price_btc'])
	price_usd = float(crypto['price_usd'])
	if local_price_str not in crypto: # API failed to convert to local price
		local_price = float(currency.convert('USD', base_currency, price_usd))
	else:
		local_price = float(crypto[local_price_str])
	# dont have bitcoin icon yet :(
	crypto['price_btc'] = currency.pretty(price_btc, 'BTC', abbrev=False)
	crypto['price_usd'] = currency.pretty(price_usd, 'USD')
	crypto[local_price_str] = currency.pretty(local_price, base_currency)
	return crypto

def get_data(tracked_coins):
	""" request coinmarketcap API for list of cryptos each stored in a dictionary
	return value: a dictionary with key is id of tracked cryptos list and
	value is a dict of its attributes """

	base_currency = config['general']['base_currency']
	convert_option = get_currency_to_convert_to(base_currency)
	api_url = 'https://api.coinmarketcap.com/v1/ticker/'
	api_meta_url = 'https://api.coinmarketcap.com/v1/global/'
	cryptocurrencies = requests.get(api_url, params=convert_option).json()
	meta_info = requests.get(api_meta_url).json()

	crypto_info = {}
	for crypto in cryptocurrencies:
		if crypto['id'] in tracked_coins:
			coinname = crypto['id']
			crypto_info[coinname] = process_crypto_info(crypto)
	data = {'GLOBAL': process_meta_info(meta_info), 'ticker': crypto_info}
	return data

def update_cache(crypto_info):
	""" update crypto stats from coinmarketcap to cache file """
	write_cache(get_cache_path('cache.json'), crypto_info)

# vim: nofoldenable
