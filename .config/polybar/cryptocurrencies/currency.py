#!/bin/env python

"""
This module convert from one currency to another, result will be saved in cache file
for later use. if result get from cache is older than 30 minutes request API again to
get the new value

API info:
	What it does: convert one currency to others
	Site: https://free.currencyconverterapi.com
	Call limit: 100 times per hour
	API currency values updated every 30 minutes
"""

import time

import requests

from cache import get_path, read_cache, write_cache

cache_path = get_path('currency_cache')
cache = {} if read_cache(cache_path) is None else read_cache(cache_path)

def check_update(from_currency, to_currency):
	""" check if last update is over 30 mins ago. if so return True to update, else False """
	# if currency never get converted before
	if from_currency not in cache:
		cache[from_currency] = {}
	if cache[from_currency].get(to_currency) is None:
		cache[from_currency][to_currency] = {'last_update': 0}
	last_update = float(cache[from_currency][to_currency]['last_update'])
	if time.time() - last_update >= 30 * 60: # if last update is more than 30 min ago
		return True
	return False

def update_cache(from_currency, to_currency):
	""" update from_currency to_currency pair in cache if
	last update for that pair is over 30 minutes ago by request API info """
	if check_update(from_currency, to_currency) is True:
		cache[from_currency][to_currency]['value'] = convert_using_api(from_currency, to_currency)
		cache[from_currency][to_currency]['last_update'] = time.time()
		write_cache(cache_path, cache)

def convert_using_api(from_currency, to_currency):
	""" convert from from_currency to to_currency by requesting API """
	convert_str = from_currency + '_' + to_currency
	options = {'compact': 'ultra', 'q': convert_str}
	api_url = 'https://free.currencyconverterapi.com/api/v5/convert'
	result = requests.get(api_url, params=options).json()
	return result[convert_str]

def convert(from_currency, to_currency, from_currency_price=1):
	""" convert from from_currency to to_currency using cached info """
	update_cache(from_currency, to_currency)
	return cache[from_currency][to_currency]['value'] * from_currency_price

_symbol = {
		'ALL': 'Lek',
		'AFN': '؋',
		'ARS': '$',
		'AWG': 'ƒ',
		'AUD': '$',
		'AZN': '₼',
		'BSD': '$',
		'BBD': '$',
		'BYN': 'Br',
		'BZD': 'BZ$',
		'BMD': '$',
		'BOB': '$b',
		'BAM': 'KM',
		'BWP': 'P',
		'BGN': 'лв',
		'BRL': 'R$',
		'BND': '$',
		'KHR': '៛',
		'CAD': '$',
		'KYD': '$',
		'CLP': '$',
		'CNY': '¥',
		'COP': '$',
		'CRC': '₡',
		'HRK': 'kn',
		'CUP': '₱',
		'CZK': 'Kč',
		'DKK': 'kr',
		'DOP': 'RD$',
		'XCD': '$',
		'EGP': '£',
		'SVC': '$',
		'EUR': '€',
		'FKP': '£',
		'FJD': '$',
		'GHS': '¢',
		'GIP': '£',
		'GTQ': 'Q',
		'GGP': '£',
		'GYD': '$',
		'HNL': 'L',
		'HKD': '$',
		'HUF': 'Ft',
		'ISK': 'kr',
		'INR': '₹',
		'IDR': 'Rp',
		'IRR': '﷼',
		'IMP': '£',
		'ILS': '₪',
		'JMD': 'J$',
		'JPY': '¥',
		'JEP': '£',
		'KZT': 'лв',
		'KPW': '₩',
		'KRW': '₩',
		'KGS': 'лв',
		'LAK': '₭',
		'LBP': '£',
		'LRD': '$',
		'MKD': 'ден',
		'MYR': 'RM',
		'MUR': '₨',
		'MXN': '$',
		'MNT': '₮',
		'MZN': 'MT',
		'NAD': '$',
		'NPR': '₨',
		'ANG': 'ƒ',
		'NZD': '$',
		'NIO': 'C$',
		'NGN': '₦',
		'NOK': 'kr',
		'OMR': '﷼',
		'PKR': '₨',
		'PAB': 'B/.',
		'PYG': 'Gs',
		'PEN': 'S/.',
		'PHP': '₱',
		'PLN': 'zł',
		'QAR': '﷼',
		'RON': 'lei',
		'RUB': '₽',
		'SHP': '£',
		'SAR': '﷼',
		'RSD': 'Дин.',
		'SCR': '₨',
		'SGD': '$',
		'SBD': '$',
		'SOS': 'S',
		'ZAR': 'R',
		'LKR': '₨',
		'SEK': 'kr',
		'CHF': 'CHF',
		'SRD': '$',
		'SYP': '£',
		'TWD': 'NT$',
		'THB': '฿',
		'TTD': 'TT$',
		'TRY': '₺',
		'TVD': '$',
		'UAH': '₴',
		'GBP': '£',
		'USD': '$',
		'UYU': '$U',
		'UZS': 'лв',
		'VEF': 'Bs',
		'VND': '₫',
		'YER': '﷼',
		'ZWD': 'Z$'
		}

def symbol(currency):
	""" return symbol of currency """
	return _symbol[currency]

def main():
	fr = 'EUR'
	to = 'JPY'
	print('WARNING: API limit 100 calls per hour')
	print('1 {} worths {} {}'.format(fr, convert(fr, to), to))

if __name__ == '__main__':
	main()

# vim: nofoldenable
