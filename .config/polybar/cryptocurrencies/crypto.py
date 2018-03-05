#!/usr/bin/env python3

""" print out cryptos info from cache on polybar """

import argparse
import os
import sys

from exceptions import ConnectionError, HTTPError, Timeout
from util import color_polybar
import config
import cache

class State():
	""" get set current state
	state type:
		display: percentage, price
		currency: usd, local
	"""
	toggling = {
			'display': {'percentage': 'price', 'price': 'percentage'},
			'currency': {'usd': 'local', 'local': 'usd'},
			}
	default_state = {
			'currency': 'usd',
			'display': 'percentage',
			}

	def __init__(self):
		cwd = os.path.dirname(os.path.realpath(__file__))
		self.toggle_path = os.path.join(cwd, 'togglestate')
		self.state = {}
		self.state['display'] = self.init_state('display')
		self.state['currency'] = self.init_state('currency')

	def init_state(self, statetype):
		""" get state info from file """
		path = os.path.join(self.toggle_path, statetype)
		if not os.path.exists(path) or os.stat(path).st_size == 0: # file not exist
			return self.default_state[statetype]
		with open(path, 'r') as file:
			return file.read()

	def get(self, statetype):
		""" get state of display or currency. use when toggle format """
		return self.state[statetype]

	def set(self, statetype, attr):
		""" set state of display or currency. use when toggle format """
		self.state[statetype] = attr
		self.save(statetype, attr)

	def save(self, statetype, attr):
		""" set state of display or currency. use when toggle format """
		path = os.path.join(self.toggle_path, statetype)
		with open(path, 'w+') as file:
			file.write(attr)

	def toggle(self, statetype):
		""" toggle display mode (percentage, price) in config file """
		attr = self.get(statetype)
		self.set(statetype, self.toggling[statetype][attr])

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

config = config.read()
currencies = cache.read('cache.json')['ticker']
state = State()
args = get_args()

def get_color(cryptoname):
	""" Get color depend on how large the number is (use 24-hour percentage change) """
	change_24h = float(currencies[cryptoname]['percent_change_24h'])

	if change_24h > 3:
		return 'green'
	elif 3 >= change_24h >= -3:
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

def print_cryptos_info():
	""" print cryptos info on polybar """
	for currency in currencies:
		icon = get_icon(currency)
		if state.get('display') == 'percentage':
			sys.stdout.write('{} {} '.format(icon, get_24h_change(currency)))
		elif state.get('display') == 'price':
			if state.get('currency') == 'usd':
				sys.stdout.write('{} {} '.format(icon, get_usd_price(currency)))
			elif state.get('currency') == 'local':
				sys.stdout.write('{} {} '.format(icon, get_local_price(currency)))

def main():
	if args.update:
		try:
			import update
			update.update_cache()
		except (ConnectionError, HTTPError, Timeout):
			sys.stdout.write(color_polybar('....', 'red'))
			sys.exit(1)
	else:
		if args.toggle == 'display':
			state.toggle('display')
		elif args.toggle == 'currency':
			state.set('display', 'price')
			state.toggle('currency')
	print_cryptos_info()

if __name__ == '__main__':
	main()

# vim: nofoldenable
