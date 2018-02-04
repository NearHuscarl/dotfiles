#!/bin/env python

""" cache module with utility functions to interact with cache file using json format """

import json
import os

def get_path(filename='cache_example'):
	""" get file path """
	cwd = os.path.dirname(os.path.realpath(__file__))
	return os.path.join(cwd, filename)

def read_cache(file_path):
	"""
	parameter: file_path - path to cache file
	return: data after parsing json file"""
	if not os.path.exists(file_path) or os.stat(file_path).st_size == 0:
		return None
	with open(file_path, 'r') as file:
		return json.load(file)

def write_cache(cache_path, data):
	""" write data to cache file
	parameters:
		cache_path - path to cache file
		data - data to write to cache file"""
	with open(cache_path, 'w') as file:
		if data is not None:
			json.dump(data, file, indent=3, sort_keys=True)

def main():
	path = get_path() # path = {$PWD}/cache_example
	cache = read_cache(path) if read_cache(path) is not None else {}
	# do stuff
	cache['key'] = {'key_1': {'key_2': 'value'}}
	cache['another_key'] = {'a_number': 8}
	# ...
	write_cache(path, cache)
	print('Cache created: ' + path)

if __name__ == '__main__':
	main()

# vim: nofoldenable
