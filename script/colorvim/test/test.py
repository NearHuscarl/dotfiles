#!/bin/env python

""" Unit test output of colorvim command """

import os
from glob import glob
import unittest
from unittest import mock

import colorvim

class TestColorvim(unittest.TestCase):
	""" Test colorvim command """

	@classmethod
	def setUpClass(cls):
		""" Run before all the tests """
		cwd = os.getcwd()
		cls.test1_path = os.path.join(cwd, 'test1.yaml')
		cls.test2_path = os.path.join(cwd, 'test2.yaml')
		cls.test3_path = os.path.join(cwd, 'test3.yaml')
		cls.test4_path = os.path.join(cwd, 'test4.yaml')
		cls.test5_path = os.path.join(cwd, 'test5.yaml')
		cls.test6_path = os.path.join(cwd, 'test6.yaml')
		cls.test7_path = os.path.join(cwd, 'test7.yaml')
		cls.test8_path = os.path.join(cwd, 'test8.yaml')
		cls.test9_path = os.path.join(cwd, 'test9.yaml')

	@classmethod
	def tearDownClass(cls):
		""" Cleanup all output files after all the tests except test1.vim """
		for file in glob('*.vim'):
			if file != 'test1.vim':
				os.remove(file)

	def setUp(self):
		""" Run before every test """
		pass

	def tearDown(self):
		""" Run after every test """
		pass

	def test_cmd(self):
		""" Test command exit status """
		self.assertEqual(os.system('colorvim ' + self.test1_path), 0)

	def test_rgb2hex(self):
		""" Test hex2rgb() """
		self.assertEqual(colorvim.hex2rgb('#1234ab'), 'rgb(18, 52, 171)')
		self.assertEqual(colorvim.hex2rgb('#000000'), 'rgb(0, 0, 0)')
		self.assertEqual(colorvim.hex2rgb('#ffffff'), 'rgb(255, 255, 255)')

	def test_hex2rgb(self):
		""" Test rgb2hex() """
		self.assertEqual(colorvim.rgb2hex('rgb(1, 100, 200)'), '#0164c8')
		self.assertEqual(colorvim.rgb2hex('rgb(34,   99,  0)'), '#226300')
		self.assertEqual(colorvim.rgb2hex('rgb(255,6,43)'), '#ff062b')

	def test_author_is_empty(self):
		""" Test fail when empty author field dont raise exception NameError """
		colorvim.yaml_path = self.test2_path
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_author()

		colorvim.yaml_path = self.test3_path
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_author()

	def test_default_description(self):
		""" Test default description is which should be '<name> colorscheme' """
		colorvim.yaml_path = self.test4_path
		colorvim.color_dict = colorvim.parse_yaml()

		self.assertEqual(colorvim.get_description(), 'test2 colorscheme')

	def test_background_option(self):
		""" Test: default background should be 'dark', value should be 'dark' or 'light' only """
		colorvim.yaml_path = self.test5_path
		colorvim.color_dict = colorvim.parse_yaml()
		self.assertEqual(colorvim.get_background(), 'dark')

		colorvim.yaml_path = self.test6_path
		colorvim.color_dict = colorvim.parse_yaml()
		self.assertEqual(colorvim.get_background(), 'dark')

		colorvim.yaml_path = self.test7_path
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_background()

	def test_name_is_empty(self):
		""" Test fail when empty name field dont raise exception NameError """
		colorvim.yaml_path = self.test8_path
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_name()

		colorvim.yaml_path = self.test9_path
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_name()

if __name__ == '__main__':
	unittest.main()

# vim: nofoldenable
