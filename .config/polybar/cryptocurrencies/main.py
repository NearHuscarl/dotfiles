#!/usr/bin/env python3

""" print out cryptos info from cache on polybar """

import argparse
import sys

from util import color_polybar
from config import get_config_path, read_config, write_config
from crypto import update_cache, get_data

config_path = get_config_path()
config = read_config(config_path)

coinnames = [x for x in config.sections() if x != 'general']
data = get_data(coinnames)
currencies = data['ticker']
meta = data['GLOBAL']

def get_arg():
	""" get script argument: display percentage or price """
	parser = argparse.ArgumentParser(description='Display cryptocurrencies statistics')
	parser.add_argument('--display', type=str, nargs='?', default='percentage',
			help='format to display: percentage or price')
	parser.add_argument('--meta', action='store_true',
			help='print meta info like cap market')
	return parser.parse_args()

def get_color(cryptoname):
	""" Get color depend on how large the number is (use 24-hour percentage change) """
	change_1h = float(currencies[cryptoname]['percent_change_1h'])

	if change_1h > 3:
		return 'green'
	elif 3 >= change_1h >= -3:
		return 'yellow'
	return 'red'

def get_icon_market_cap():
	""" 24 hour volume icon """
	return color_polybar(config['global']['icon_market_cap'], 'white')

def get_icon_24h_volume():
	""" market cap icon """
	return color_polybar(config['global']['icon_24h_volume'], 'white')

def get_market_cap():
	""" total market cap in usd """
	return color_polybar(meta['total_market_cap_usd'], 'main')

def get_24h_volume():
	""" volume in 24h in usd """
	return color_polybar(meta['total_24h_volume_usd'], 'main')

def get_24h_change(cryptoname):
	""" get 24h change in percent for crypto_id + polybar color """
	return color_polybar(currencies[cryptoname]['percent_change_24h'] + '%', get_color(cryptoname))

def get_1h_change(cryptoname):
	""" get 1h change in percent for crypto_id + polybar color """
	return color_polybar(currencies[cryptoname]['percent_change_1h'] + '%', get_color(cryptoname))

def get_usd_price(cryptoname):
	""" get usd price converted from 1 crypto_id + polybar color """
	return color_polybar(currencies[cryptoname]['price_usd'], get_color(cryptoname))

def get_local_price(cryptoname):
	""" get local price converted from 1 crypto_id + polybar color """
	local_price_str = 'price_' + config['general']['base_currency']
	return color_polybar(currencies[cryptoname][local_price_str], get_color(cryptoname))

def get_icon(cryptoname):
	""" get icon + polybar color """
	icon = config[cryptoname].get('icon', None)
	if icon is None:
		return currencies[cryptoname]['symbol']
	return color_polybar(config[cryptoname]['icon'], 'main')

def print_meta_info():
	""" print meta info like cap market"""
	sys.stdout.write('{} {} '.format(get_icon_market_cap(), get_market_cap()))
	sys.stdout.write('{} {} '.format(get_icon_24h_volume(), get_24h_volume()))


def print_cryptos_info():
	""" print cryptos info on polybar """
	display = config['general']['display']
	for currency in currencies:
		icon = get_icon(currency)
		if display == 'percentage':
			sys.stdout.write('{} {} '.format(icon, get_1h_change(currency)))
		elif display == 'price':
			sys.stdout.write('{} {} '.format(icon, get_local_price(currency)))

def toggle_display():
	""" toggle display mode (percentage, price) in config file """
	toggle = {'percentage': 'price', 'price': 'percentage'}
	config['general']['display'] = toggle.get(config['general']['display'], 'percentage')
	write_config(config_path, config)

def main():
	arg = get_arg()
	if arg.display == 'toggle':
		toggle_display()
	if arg.meta:
		print_meta_info()
	else:
		print_cryptos_info()
	update_cache(data)

if __name__ == '__main__':
	main()

# vim: nofoldenable
