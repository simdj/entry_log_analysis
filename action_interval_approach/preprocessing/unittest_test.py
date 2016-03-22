import random
import unittest

class TestSequenceFunctions(unittest.TestCase):
	def setUp(self):
		self.seq = list(range(10))

	def test_suhffle(self):
		random.shuffle(self.seq)
		self.seq.sort()
		self.assertEqual(self.seq, list(range(10)))

		self.assertRaises(TypeError, random.shuffle, (1,2,3))

if __name__=='__main__':
	unittest.main()