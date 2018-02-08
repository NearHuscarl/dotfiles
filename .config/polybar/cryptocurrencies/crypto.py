#!/usr/bin/env python3

""" print out cryptos info from cache on polybar """

import argparse
import sys

from util import color_polybar
import config
import cache

config = config.read()
currencies = cache.read('cache.json')['ticker']

def get_args():
	""" get script argument: display percentage or price """
	parser = argparse.ArgumentParser(description='Display cryptocurrencies statistics')
	parser.add_argument('--toggle-display', action='store_true',
			help='toggle display format: percentage or price')
	parser.add_argument('--toggle-currency', action='store_true',
			help='toggle currency to convert to: usd or local price specified in config')

	parsed_args = parser.parse_args()
	if parsed_args.currency == 'default': # override --display argument if --currency is given
		parsed_args.currency = 'usd'
	else:
		parsed_args.display = 'price'
	return parsed_args

args = get_args()

def get_color(cryptoname):
	""" Get color depend on how large the number is (use 24-hour percentage change) """
	change_1h = float(currencies[cryptoname]['percent_change_1h'])

	if change_1h > 3:
		return 'green'
	elif 3 >= change_1h >= -3:
		return 'yellow'
	return 'red'

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
	local_price_str = 'price_' + config['global']['base_currency'].lower()
	return color_polybar(currencies[cryptoname][local_price_str], get_color(cryptoname))

def get_icon(cryptoname):
	""" get icon + polybar color """
	icon = config[cryptoname].get('icon', None)
	if icon is None:
		return currencies[cryptoname]['symbol']
	return color_polybar(config[cryptoname]['icon'], 'main')

def get_display_state():
	return -1

def set_display_state(state):
	pass

def print_cryptos_info():
	""" print cryptos info on polybar """
	display = get_display_state()
	for currency in currencies:
		icon = get_icon(currency)
		if display == 'percentage':
			sys.stdout.write('{} {} '.format(icon, get_1h_change(currency)))
		elif display == 'price':
			if args.currency == 'usd':
				sys.stdout.write('{} {} '.format(icon, get_local_price(currency)))
			elif args.currency == 'local':
				sys.stdout.write('{} {} '.format(icon, get_usd_price(currency)))

def toggle_display():
	""" toggle display mode (percentage, price) in config file """
	toggle = {'percentage': 'price', 'price': 'percentage'}
	set_display_state(toggle[get_display_state()])

def main():
	if args.display == 'toggle':
		toggle_display()
	print_cryptos_info()

if __name__ == '__main__':
	main()

# vim: nofoldenable
