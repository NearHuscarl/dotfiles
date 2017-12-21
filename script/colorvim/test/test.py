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

		for i in range(0, 30):
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
		self.assertEqual(os.system('colorvim ' + self.test_paths[1]), 0)

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
		colorvim.yaml_path = self.test_paths[2]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_author()

		colorvim.yaml_path = self.test_paths[3]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_author()

	def test_default_description(self):
		""" Test default description is which should be '<name> colorscheme' """
		colorvim.yaml_path = self.test_paths[4]
		colorvim.color_dict = colorvim.parse_yaml()

		self.assertEqual(colorvim.get_description(), 'test4 colorscheme')

	def test_background_option(self):
		""" Test: default background should be 'dark', value should be 'dark' or 'light' only """
		colorvim.yaml_path = self.test_paths[5]
		colorvim.color_dict = colorvim.parse_yaml()
		self.assertEqual(colorvim.get_background(), 'dark')

		colorvim.yaml_path = self.test_paths[6]
		colorvim.color_dict = colorvim.parse_yaml()
		self.assertEqual(colorvim.get_background(), 'dark')

		colorvim.yaml_path = self.test_paths[7]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_background()

	def test_name_is_empty(self):
		""" Test fail when empty name field dont raise exception NameError """
		colorvim.yaml_path = self.test_paths[8]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_name()

		colorvim.yaml_path = self.test_paths[9]
		colorvim.color_dict = colorvim.parse_yaml()
		with self.assertRaises(NameError):
			colorvim.get_name()

	def test_color_name_is_in_palette(self):
		""" Test if color name is in color palette """
		colorvim.yaml_path = self.test_paths[10]
		colorvim.color_dict = colorvim.parse_yaml()
		colorvim.set_up(colorvim.color_dict)

		with self.assertRaises(NameError):
			colorvim.get_hi_group_value('Normal')
		with self.assertRaises(NameError):
			colorvim.get_hi_group_value('Comment')

	def test_attr_val_is_valid_name(self):
		""" Test if attribute value is a valid name """
		colorvim.yaml_path = self.test_paths[11]
		colorvim.color_dict = colorvim.parse_yaml()
		colorvim.set_up(colorvim.color_dict)

		with self.assertRaises(NameError):
			colorvim.get_hi_group_value('Comment')

	def test_color_group_has_minimum_value(self):
		"""
		Test if color group has at least 2 value (bg and fg color)
		'_' is also a value indicate NONE
		"""
		colorvim.yaml_path = self.test_paths[12]
		colorvim.color_dict = colorvim.parse_yaml()
		colorvim.set_up(colorvim.color_dict)

		with self.assertRaises(ValueError):
			colorvim.get_hi_group_value('Comment')

	def test_transparent_option(self):
		""" Test if transparent is true, ctermbg in transp group is NONE  """
		colorvim.yaml_path = self.test_paths[13]
		colorvim.color_dict = colorvim.parse_yaml()
		colorvim.set_up(colorvim.color_dict)

		transp_group = ['Normal', 'LineNr', 'Folded', 'SignColumn']
		for group in transp_group:
			if group in colorvim.color_dict['group']:
				err_msg = ('trasparent is set. {} group ctermbg should be NONE, '
						'found {} instead ').format(group, colorvim.get_hi_group_value(group)[1])
				self.assertEqual(colorvim.get_hi_group_value(group)[1], 'NONE', err_msg)

	def test_colorname_transform(self):
		""" Test transform color name to lowercase """
		colorvim.yaml_path = self.test_paths[14]
		colorvim.color_dict = colorvim.parse_yaml()
		colorvim.set_up(colorvim.color_dict)

		self.assertTrue(colorvim.get_group_dict()['Normal'].islower())
		self.assertTrue(colorvim.get_group_dict()['Comment'].islower())

		self.assertIn('dark', colorvim.get_color())
		self.assertIn('gray', colorvim.get_color())
		self.assertIn('snow', colorvim.get_color())

	def test_multiple_attribute(self):
		""" Test multiple attribute getters """
		colorvim.yaml_path = self.test_paths[15]
		colorvim.color_dict = colorvim.parse_yaml()

		colorvim.set_up(colorvim.color_dict)

		self.assertEqual(colorvim.get_hi_group_value('Normal')[4], 'reverse')
		self.assertEqual(colorvim.get_hi_group_value('Comment')[4], 'reverse,bold,underline')
		self.assertEqual(colorvim.get_hi_group_value('Identify')[4], 'reverse,bold')
		with self.assertRaises(NameError):
			colorvim.get_hi_group_value('Function')
		self.assertEqual(colorvim.get_hi_group_value('PreProc')[4], 'NONE')

	def test_empty_group(self):
		""" empty group should throw error """
		colorvim.yaml_path = self.test_paths[16]
		colorvim.color_dict = colorvim.parse_yaml()

		with self.assertRaises(KeyError):
			colorvim.set_up(colorvim.color_dict)

	def test_empty_palette(self):
		""" empty palette should throw error """
		colorvim.yaml_path = self.test_paths[17]
		colorvim.color_dict = colorvim.parse_yaml()

		with self.assertRaises(KeyError):
			colorvim.set_up(colorvim.color_dict)

	def test_transparent_group_option(self):
		""" transparent group option should override default transparent group """
		colorvim.yaml_path = self.test_paths[18]
		colorvim.color_dict = colorvim.parse_yaml()

		self.assertEqual(colorvim.get_transparent_group(), ['Normal', 'Statusline'])

	def test_no_transparent_group_option(self):
		""" omit transparent group option should return default transparent group """
		colorvim.yaml_path = self.test_paths[19]
		colorvim.color_dict = colorvim.parse_yaml()

		self.assertEqual(colorvim.get_transparent_group(), colorvim.default_transparent_group)


if __name__ == '__main__':
	unittest.main()

# vim: nofoldenable
