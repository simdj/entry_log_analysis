"""
Assuming this is file mymodule.py. then this string being the
first statement in the file. will become the "mymodule" module's
docstring when the file is imported
"""


class MyClass(object):
	""" The class's docstring """
	def my_method(self):
		""" The method's docstring """
		print(1);


def my_function():
	"""the function's docstring """
	print("hello")


def test_func(a,b):
	""" 
	>>> test_func(2,3)
	6
	>>> test_func('a',3)
	'aaa'
	"""
	return a*b;

# python -m doctest -v mymodule.py
