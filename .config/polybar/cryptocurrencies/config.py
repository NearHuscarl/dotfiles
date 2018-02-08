#!/bin/env python

""" wrapper functions to use configparser module easier """

import configparser
import os

def get_config_path(filename):
	""" return config file path. default is {$PWD}/config """
	cwd = os.path.dirname(os.path.realpath(__file__))
	return os.path.join(cwd, filename)

def read(filename='config'):
	""" return ConfigParser object
	parameter: config_path - path to config file
	return: ConfigParser object"""
	config = configparser.ConfigParser()
	config_path = get_config_path(filename)
	with open(config_path, 'r') as file:
		config.read_file(file)
	return config

def write(config_obj, filename='config'):
	""" write config to config file
	parameters:
		config_path - path to config file
		config_obj - ConfigParser obj to write into config file"""
	config_path = get_config_path(filename)
	with open(config_path, 'w') as file:
		config_obj.write(file)
	with open(config_path, 'a') as file: # add modeline to set filetype for vim editor
		file.write("# vim: ft=dosini")

def main():
	config = read('example_config') # path = {$PWD}/example_config
	# config[attr] = value
	# ...
	write(config, 'example_config')

if __name__ == '__main__':
	main()

# vim: nofoldenable
