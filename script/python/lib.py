#!/bin/env python

""" list of uitility functions waiting to be copied """

import os

def mkdir(path):
	""" create directory if not exists """
	if not os.path.isdir(path):
		os.makedirs(path)

def touch(path, content=''):
	""" create new file like a boss """
	dirname = os.path.dirname(path)
	mkdir(dirname)
	with open(path, 'w') as file:
		file.write(content)

def isfile(path):
	""" is file that not empty """
	if not os.path.isfile(path) or os.stat(path).st_size == 0:
		return False
	return True

def put(line, filename):
	""" append a line to filename """
	if not os.path.isfile(filename):
		touch(filename)

	with open(filename, 'a') as file:
		file.write(line + '\n')

def read(filename, isdict=False):
	""" read content from a file
	return:
		if isdict == True:
			a dictionary where each key is mapped to a line with None value
		else:
			a list of lines
	"""
	if not os.path.isfile(filename):
		touch(filename)

	with open(filename, 'r') as file:
		words = file.readlines()

	if isdict:
		return {word.strip(): None for word in words}
	return [word.strip() for word in words]

def lsfile(path=None, filetype='all'):
	""" list files in path. Default is search for both file and dir in cwd """
	if path is None:
		path = os.getcwd()

	if filetype == 'file':
		return [file for file in os.listdir(path) if os.path.isfile(os.path.join(path, file))]

	elif filetype == 'dir':
		return [file for file in os.listdir(path) if os.path.isdir(os.path.join(path, file))]

	return os.listdir(path) # all

import time

def timer(function):
	""" decorator to time function call
	@timer
	def test():
		for _ in range(0, 10000):
			pass

	test()
	test.elapsed
	"""
	def time_function_call(*args, **kwargs):
		""" get time of function call """
		start = time.time()
		function_result = function(*args, **kwargs)
		end = time.time()
		time_function_call.elapsed = end - start

		return function_result

	return time_function_call

import logging

def settup_logger(name, logfile, level=logging.INFO):
	""" setup logger. Usage:

	LOG = settup_logger('info', 'scraping.log', level=logging.INFO)

	LOG.info('info message')
	LOG.debug('debug message')
	"""
	formatter = logging.Formatter(
			'%(filename)-10s %(funcName)-10s %(lineno)-3d %(levelname)-8s [%(asctime)s] %(message)s')

	handler = logging.FileHandler(logfile)
	handler.setFormatter(formatter)

	logger = logging.getLogger(name)
	logger.setLevel(level)
	logger.addHandler(handler)

	return logger

def main():
	pass

if __name__ == '__main__':
	main()

# vim: nofoldenable
