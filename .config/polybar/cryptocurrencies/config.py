#!/bin/env python

""" wrapper functions to use configparser module easier """

import configparser
import os

def get_config_path(filename='config'):
	""" return config file path. default is {$PWD}/config """
	cwd = os.path.dirname(os.path.realpath(__file__))
	return os.path.join(cwd, filename)

def read_config(config_path):
	""" return ConfigParser object
	parameter: config_path - path to config file
	return: ConfigParser object"""
	config = configparser.ConfigParser()
	with open(config_path, 'r') as file:
		config.read_file(file)
	return config

def write_config(config_path, config_obj):
	""" write config to config file
	parameters:
		config_path - path to config file
		config_obj - ConfigParser obj to write into config file"""
	with open(config_path, 'w') as file:
		config_obj.write(file)
	with open(config_path, 'a') as file: # add modeline to set filetype for vim editor
		file.write("# vim: ft=dosini")

def main():
	path = get_config_path('example_config') # path = {$PWD}/example_config
	config = read_config(path)
	# config[attr] = value
	# ...
	write_config(path, config)

if __name__ == '__main__':
	main()

# vim: nofoldenable
