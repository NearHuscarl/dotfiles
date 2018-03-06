#!/usr/bin/env python3

""" print out cryptos info from cache on polybar """

import argparse
import os
import sys

from exceptions import ConnectionError, HTTPError, Timeout
import polybar
import util

def get_args():
	""" get script argument: display percentage or price """

	def toggle(arg):
		""" handle --toggle argument """
		if arg != 'display' and arg != 'currency':
			raise argparse.ArgumentTypeError("value must be 'display' or 'currency'")
		return arg

	parser = argparse.ArgumentParser(description='Display cryptocurrencies statistics')
	parser.add_argument('--toggle', type=toggle,
			help='toggle display (percentage|price) or currency (usd|local)')
	parser.add_argument('--update', action='store_true',
			help='update cache and display new info about cryptocurrencies')
	return parser.parse_args()

def get(attr):
	""" get attribute info from file, return default attributes if file not exists """
	default = {'currency': 'usd', 'display': 'percentage'}

	cachepath = os.path.join(os.environ['HOME'], '.cache/polybar/crypto')
	path = os.path.join(cachepath, attr)

	if not os.path.exists(path) or os.stat(path).st_size == 0: # file not exist
		util.touch(path, default[attr])
		return default[attr]

	with open(path, 'r') as file:
		return file.read()

def toggle(attr):
	""" toggle cryptocurrencies attributes """
	value = get(attr)
	toggling = {
			'display': {'percentage': 'price', 'price': 'percentage'},
			'currency': {'usd': 'local', 'local': 'usd'},
			}

	cachepath = os.path.join(os.environ['HOME'], '.cache/polybar/crypto')
	path = os.path.join(cachepath, attr)

	with open(path, 'w+') as file:
		file.write(toggling[attr][value])

def get_color(percent):
	""" Get color depend on how large the number is (use 24-hour percentage change) """
	percent = float(percent.strip('%'))

	if percent > 3:
		return 'green'
	elif 3 >= percent >= -3:
		return 'yellow'
	return 'red'

def print_cryptos():
	""" print cryptos info on polybar """
	cryptos = util.readcache('cache.json')['ticker']
	config = util.readconfig()
	display = get('display')
	currency = get('currency')

	for crypto in cryptos:
		icon = config[crypto].get('icon', cryptos[crypto]['symbol'])
		change_24h = cryptos[crypto]['percent_change_24h'] + '%'
		color = get_color(change_24h)

		if display == 'percentage':
			polybar.cprint('{main}' + icon + ' {color}' + change_24h + ' ', color=color)

		elif display == 'price':

			if currency == 'usd':
				usd_price = cryptos[crypto]['price_usd']
				polybar.cprint('{main}' + icon + ' {color}' + usd_price + ' ', color=color)

			elif currency == 'local':
				local = config['global']['base_currency'].lower()
				local_price = cryptos[crypto]['price_' + local]
				polybar.cprint('{main}' + icon + ' {color}' + local_price, color=color)

def main():
	args = get_args()

	if args.update:
		try:
			import update
			update.update_cache()
		except (ConnectionError, HTTPError, Timeout):
			polybar.cprint('{red}....{reset}')
			sys.exit(1)

	else:
		if args.toggle == 'display':
			toggle('display')

		elif args.toggle == 'currency':
			toggle('currency')

	print_cryptos()

if __name__ == '__main__':
	main()

# vim: nofoldenable
