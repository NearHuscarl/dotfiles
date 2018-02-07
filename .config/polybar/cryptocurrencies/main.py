#!/usr/bin/env python3

""" Cryptocurrencies module for polybar """

import argparse
import sys

from util import color_polybar
from config import get_config_path, read_config, write_config
from crypto import update_cache, get_data

config_path = get_config_path()
config = read_config(config_path)
coinnames = [x for x in config.sections() if x != 'general']
currencies = get_data(coinnames)

def get_arg():
	""" get script argument: display percentage or price """
	parser = argparse.ArgumentParser(description='Display cryptocurrencies statistics')
	parser.add_argument('--display', type=str, nargs='?', default='percentage',
			help='format to display: percentage or price')
	return parser.parse_args()

def get_color(cryptoname):
	""" Get color depend on how large the number is (use 24-hour percentage change) """
	change_1h = float(currencies[cryptoname]['percent_change_1h'])

	if change_1h > 3:
		return 'green'
	elif 3 >= change_1h >= -3:
		return 'yellow'
	return 'red'

def get_24_hour_change(cryptoname):
	""" get 24h change in percent for crypto_id + polybar color """
	return color_polybar(currencies[cryptoname]['percent_change_24h'] + '%', get_color(cryptoname))

def get_1_hour_change(cryptoname):
	""" get 1h change in percent for crypto_id + polybar color """
	return color_polybar(currencies[cryptoname]['percent_change_1h'] + '%', get_color(cryptoname))

def get_usd_price(cryptoname):
	""" get usd price converted from 1 crypto_id + polybar color """
	return color_polybar(currencies[cryptoname]['price_usd'], get_color(cryptoname))

def get_local_price(cryptoname):
	""" get local price converted from 1 crypto_id + polybar color """
	local_price_str = 'price_' + config['general']['base_currency']
	return color_polybar(currencies[cryptoname][local_price_str], get_color(cryptoname))

def get_icon(crypto_id):
	""" get icon + polybar color """
	icon = config[crypto_id].get('symbol', None)
	if icon is None:
		return icon
	return color_polybar(config[crypto_id]['symbol'], 'main')

def print_cryptos_info():
	""" print cryptos info on polybar """
	display = config['general']['display']
	for currency in currencies:
		icon = get_icon(currency)
		if icon is None: # update_config() write to file not finish yet, wait for next turn
			continue
		if display == 'percentage':
			sys.stdout.write('{} {} '.format(icon, get_1_hour_change(currency)))
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
	print_cryptos_info()
	update_cache(currencies)

if __name__ == '__main__':
	main()

# vim: nofoldenable
