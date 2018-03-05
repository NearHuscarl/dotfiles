#!/usr/bin/env python3

"""
Update crypto statistics to cache file using coinmarketcap API
Use currency.converter() if currency to convert to not supported,
"""

import requests

# pip install nh-currency
import currency
import config
import cache

config = config.read()

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

	base_currency = config['global']['base_currency'].lower()
	local_price_str = 'price_' + base_currency

	price_btc = float(crypto['price_btc'])
	price_usd = currency.rounding(crypto['price_usd'], 'USD')
	if local_price_str not in crypto: # API failed to convert to local price
		price = currency.convert('USD', base_currency, price_usd)
		local_price = currency.rounding(price, local_price_str)
	else:
		local_price = currency.rounding(crypto[local_price_str], base_currency)
	# dont have bitcoin icon yet :(
	crypto['price_btc'] = currency.pretty(price_btc, 'BTC', abbrev=False)
	crypto['price_usd'] = currency.pretty(price_usd, 'USD')
	crypto[local_price_str] = currency.pretty(local_price, base_currency)
	return crypto

def request_info():
	""" request coinmarketcap API for cryptocurrencies and global market statistics
	return a tuple of meta and cryptos info """

	base_currency = config['global']['base_currency']
	convert_option = {'convert': base_currency}

	api_url = 'https://api.coinmarketcap.com/v1/ticker/'
	api_meta_url = 'https://api.coinmarketcap.com/v1/global/'
	cryptocurrencies = requests.get(api_url, params=convert_option).json()
	meta_info = requests.get(api_meta_url).json()

	return (meta_info, cryptocurrencies)

def update_cache():
	""" get coin info on the internet, format some values and write it to cache
	for later retrieval """
	tracked_coins = [x for x in config.sections() if x != 'global']
	meta, cryptocurrencies = request_info()
	crypto_info = {}
	for crypto in cryptocurrencies:
		if crypto['id'] in tracked_coins:
			coinname = crypto['id']
			crypto_info[coinname] = process_crypto_info(crypto)
	data = {'GLOBAL': process_meta_info(meta), 'ticker': crypto_info}
	cache.write(data, 'cache.json')

def main():
	update_cache()

if __name__ == '__main__':
	main()

# vim: nofoldenable
