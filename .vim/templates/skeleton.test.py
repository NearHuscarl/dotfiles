#!/bin/env python

""" Unit test output of colorvim command """

import os
import unittest

class TestCode(unittest.TestCase):
	""" Test template """

	@classmethod
	def setUpClass(cls):
		""" Run before all the tests """
		pass

	@classmethod
	def tearDownClass(cls):
		""" Run after all the tests """
		pass

	def setUp(self):
		""" Run before every test """
		pass

	def tearDown(self):
		""" Run after every test """
		pass

	def test_cmd(self):
		""" Test command exit status """

		self.assertEqual(os.system('echo "Test run!"'), 0)


if __name__ == '__main__':
	unittest.main()

# vim: nofoldenable
