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
		cls.test_paths = []
		dirname = os.path.dirname(os.path.realpath(__file__))

		for i in range(1, 30):
			cls.test_paths.append(os.path.join(dirname, 'test' + str(i) + '.yaml'))

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
		self.assertEqual(os.system('colorvim ' + self.test_paths[0]), 0)

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
		colorvim.yaml_path = self.test_paths[1]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_author()

		colorvim.yaml_path = self.test_paths[2]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_author()

	def test_default_description(self):
		""" Test default description is which should be '<name> colorscheme' """
		colorvim.yaml_path = self.test_paths[3]
		colorvim.color_dict = colorvim.parse_yaml()

		self.assertEqual(colorvim.get_description(), 'test4 colorscheme')

	def test_background_option(self):
		""" Test: default background should be 'dark', value should be 'dark' or 'light' only """
		colorvim.yaml_path = self.test_paths[4]
		colorvim.color_dict = colorvim.parse_yaml()
		self.assertEqual(colorvim.get_background(), 'dark')

		colorvim.yaml_path = self.test_paths[5]
		colorvim.color_dict = colorvim.parse_yaml()
		self.assertEqual(colorvim.get_background(), 'dark')

		colorvim.yaml_path = self.test_paths[6]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_background()

	def test_name_is_empty(self):
		""" Test fail when empty name field dont raise exception NameError """
		colorvim.yaml_path = self.test_paths[7]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_name()

		colorvim.yaml_path = self.test_paths[8]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_name()

	def test_color_name_is_in_palette(self):
		""" Test if color name is in color palette """
		colorvim.yaml_path = self.test_paths[9]
		colorvim.color_dict = colorvim.parse_yaml()

		with self.assertRaises(NameError):
			colorvim.get_group_attr('Normal')
		with self.assertRaises(NameError):
			colorvim.get_group_attr('Comment')

	def test_attr_val_is_valid_name(self):
		""" Test if attribute value is a valid name """
		colorvim.yaml_path = self.test_paths[10]
		colorvim.color_dict = colorvim.parse_yaml()

		with self.assertRaises(NameError):
			colorvim.get_group_attr('Comment')

	def test_color_group_has_minimum_value(self):
		"""
		Test if color group has at least 2 value (bg and fg color)
		'_' is also a value indicate NONE
		"""
		colorvim.yaml_path = self.test_paths[11]
		colorvim.color_dict = colorvim.parse_yaml()

		with self.assertRaises(ValueError):
			colorvim.get_group_attr('Comment')

	def test_transperant_option(self):
		""" Test if transparent is true, ctermbg in transp group is NONE  """
		colorvim.yaml_path = self.test_paths[12]
		colorvim.color_dict = colorvim.parse_yaml()

		transp_group = ['Normal', 'LineNr', 'Folded', 'SignColumn']
		for group in transp_group:
			if group in colorvim.color_dict['group']:
				err_msg = ('trasparent is set. {} group ctermbg should be NONE, '
						'found {} instead ').format(group, colorvim.get_group_attr(group)[1])
				self.assertEqual(colorvim.get_group_attr(group)[1], 'NONE', err_msg)

	def test_colorname_transform(self):
		""" Test transform color name to lowercase """
		colorvim.yaml_path = self.test_paths[13]
		colorvim.color_dict = colorvim.parse_yaml()

		colorvim.set_up()
		self.assertTrue(colorvim.color_dict['group']['Normal'].islower())
		self.assertTrue(colorvim.color_dict['group']['Comment'].islower())

		self.assertIn('dark', colorvim.color_dict['palette'])
		self.assertIn('gray', colorvim.color_dict['palette'])
		self.assertIn('snow', colorvim.color_dict['palette'])

	def test_multiple_attribute(self):
		""" Test multiple attribute getters """
		colorvim.yaml_path = self.test_paths[14]
		colorvim.color_dict = colorvim.parse_yaml()

		colorvim.set_up()

		self.assertEqual(colorvim.get_group_attr('Normal')[4], 'reverse')
		self.assertEqual(colorvim.get_group_attr('Comment')[4], 'reverse,bold,underline')
		self.assertEqual(colorvim.get_group_attr('Identify')[4], 'reverse,bold')
		with self.assertRaises(NameError):
			colorvim.get_group_attr('Function')
		self.assertEqual(colorvim.get_group_attr('PreProc')[4], 'NONE')

if __name__ == '__main__':
	unittest.main()

# vim: nofoldenable
