#!/bin/env python

""" wrapper functions to use configparser module easier """

import configparser
import json
import os


def mkdir(path):
	""" create directory if not exists """
	if not os.path.exists(path):
		os.makedirs(path)

def touch(path, content=None):
	""" create new file like a boss """
	dirname = os.path.dirname(path)
	mkdir(dirname)
	with open(path, 'w') as file:
		file.write(content)

def get_config_path(filename):
	""" return config file path. default is {$PWD}/config """
	cwd = os.path.dirname(os.path.realpath(__file__))
	return os.path.join(cwd, filename)

def readconfig(filename='config'):
	""" return ConfigParser object
	parameter: config_path - path to config file
	return: ConfigParser object"""
	config = configparser.ConfigParser()
	config_path = get_config_path(filename)
	with open(config_path, 'r') as file:
		config.read_file(file)
	return config

def writeconfig(config_obj, filename='config'):
	""" write config to config file
	parameters:
		config_path - path to config file
		config_obj - ConfigParser obj to write into config file"""
	config_path = get_config_path(filename)
	with open(config_path, 'w') as file:
		config_obj.write(file)
	with open(config_path, 'a') as file: # add modeline to set filetype for vim editor
		file.write("# vim: ft=dosini")

def get_cache_path(filename):
	""" get file path """
	cwd = os.path.dirname(os.path.realpath(__file__))
	return os.path.join(cwd, filename)

def readcache(filename='cache'):
	"""
	parameter: file_path - path to cache file
	return: data after parsing json file"""
	cache_path = get_cache_path(filename)
	if not os.path.exists(cache_path) or os.stat(cache_path).st_size == 0:
		return None
	with open(cache_path, 'r') as file:
		return json.load(file)

def writecache(content, filename='cache'):
	""" write data to cache file
	parameters:
		cache_path - path to cache file
		content - a data structure to save into cache file"""
	cache_path = get_cache_path(filename)
	with open(cache_path, 'w') as file:
		if content is not None:
			json.dump(content, file, indent=3, sort_keys=True)

def main():
	config = readconfig('example_config') # path = {$PWD}/example_config
	# config[attr] = value
	# ...
	writeconfig(config, 'example_config')

if __name__ == '__main__':
	main()

# vim: nofoldenable
