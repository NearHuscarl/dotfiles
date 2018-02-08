#!/usr/bin/env python3

""" print out meta info about cryptocurrencies from cache on polybar """

import sys

from util import color_polybar
import config
import cache

config = config.read()
meta = cache.read('cache.json')['GLOBAL']

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

def print_meta_info():
	""" print meta info like cap market"""
	sys.stdout.write('{} {} '.format(get_icon_market_cap(), get_market_cap()))
	sys.stdout.write('{} {} '.format(get_icon_24h_volume(), get_24h_volume()))

def main():
	print_meta_info()

if __name__ == '__main__':
	main()

# vim: nofoldenable
