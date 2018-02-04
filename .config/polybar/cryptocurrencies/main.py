#!/usr/bin/env python3

""" Cryptocurrencies module for polybar """

import argparse
import sys
import locale

from util import color_polybar
from config import get_config_path, read_config, write_config
from crypto_config import update_config

locale.setlocale(locale.LC_NUMERIC, 'en_US')
config_path = get_config_path()
config = read_config(config_path)


def get_arg():
	""" get script argument: display percentage or price """
	parser = argparse.ArgumentParser(description='Display cryptocurrencies statistics')
	parser.add_argument('--display', type=str, nargs='?', default='percentage',
			help='format to display: percentage or price')
	return parser.parse_args()

def get_color(crypto_id):
	""" Get color depend on how large the number is (use 24-hour percentage change) """
	change_24 = float(config[crypto_id]['change_24'])

	if change_24 > 3:
		return 'green'
	elif 3 >= change_24 >= -3:
		return 'yellow'
	return 'red'

def get_24_hour_change(crypto_id):
	""" get 24h change in percent for crypto_id + polybar color """
	return color_polybar(config[crypto_id]['change_24'] + '%', get_color(crypto_id))

def get_usd_price(crypto_id):
	""" get usd price converted from 1 crypto_id + polybar color """
	return color_polybar(config[crypto_id]['price_usd'] + '%', get_color(crypto_id))

def get_local_price(crypto_id):
	""" get local price converted from 1 crypto_id + polybar color """
	local_price_str = 'price_' + config['general']['base_currency']
	local_price = locale.format('%f', float(config[crypto_id][local_price_str]), grouping=True)
	return color_polybar(local_price, get_color(crypto_id))

def get_icon(crypto_id):
	""" get icon + polybar color """
	icon = config[crypto_id].get('symbol', None)
	if icon is None:
		return icon
	return color_polybar(config[crypto_id]['symbol'], 'main')

def print_cryptos_info():
	""" print cryptos info on polybar """
	cryptocurrencies = [x for x in config.sections() if x != 'general']
	for crypto in cryptocurrencies:
		icon = get_icon(crypto)
		if icon is None: # update_config() write to file not finish yet, wait for next turn
			continue
		display = config['general']['display']
		if display == 'percentage':
			sys.stdout.write('{} {} '.format(icon, get_24_hour_change(crypto)))
		elif display == 'price':
			sys.stdout.write('{} {} '.format(icon, get_local_price(crypto)))

def toggle_display():
	""" toggle display mode (percentage, price) in config file """
	toggle = {'percentage': 'price', 'price': 'percentage'}
	config['general']['display'] = toggle.get(config['general']['display'], 'percentage')
	write_config(config_path, config)

def main():
	update_config()
	arg = get_arg()
	if arg.display == 'toggle':
		toggle_display()
	print_cryptos_info()

if __name__ == '__main__':
	main()

# vim: nofoldenable
