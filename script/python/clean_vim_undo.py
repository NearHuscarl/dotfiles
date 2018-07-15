#!/bin/env python

""" remove all undo files in ~/.vim/undo/ where corresponding
file does not exist anymore """

import os

UNDO_PATH = os.path.join(os.environ['HOME'], '.vim/undo/')

def lsfile(path=None, filetype='all'):
	""" list files in path. Default is search for both file and dir in cwd """
	if path is None:
		path = os.getcwd()

	if filetype == 'file':
		return [file for file in os.listdir(path) if os.path.isfile(os.path.join(path, file))]

	elif filetype == 'dir':
		return [file for file in os.listdir(path) if os.path.isdir(os.path.join(path, file))]

	return os.listdir(path) # all

def get_undo_path(undofile):
	""" extract path from undo filename
	example:
		'%home%near%bin%000.cpp'
	would return
		'/home/near/bin/000.cpp' """
	return undofile.replace('%', os.sep)

def get_undo_file(path):
	""" get undo filename from path
	example:
		'/home/near/bin/000.cpp'
	would return
		'%home%near%bin%000.cpp' """
	return path.replace(os.sep, '%')

def get_old_undo_files():
	paths = [get_undo_path(file) for file in lsfile(UNDO_PATH)]
	old_paths = [path for path in paths if not os.path.exists(path)]

	return [get_undo_file(path) for path in old_paths]

def clear_old_vim_undo():
	old_undo_files = get_old_undo_files()

	for file in old_undo_files:
		path = os.path.join(UNDO_PATH, file)
		os.remove(path)

def main():
	""" main function """
	clear_old_vim_undo()

if __name__ == '__main__':
	main()

# vim: nofoldenable
