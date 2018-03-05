#!/usr/bin/env python3

""" print out meta info about cryptocurrencies from cache on polybar """

import polybar
import util

def print_meta_info():
	""" print meta info like cap market"""
	config = util.readconfig()
	meta = util.readcache('cache.json')['GLOBAL']

	icon_volume_24h = config['global']['icon_24h_volume']
	icon_market_cap = config['global']['icon_market_cap']

	market_cap = meta['total_market_cap_usd']
	volume_24h = meta['total_24h_volume_usd']

	polybar.cprint('{white}' + icon_market_cap + ' {main}' + market_cap + ' ')
	polybar.cprint('{white}' + icon_volume_24h + ' {main}' + volume_24h)

def main():
	print_meta_info()

if __name__ == '__main__':
	main()

# vim: nofoldenable
