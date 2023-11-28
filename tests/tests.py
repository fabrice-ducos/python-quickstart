import unittest

from myproject.main import say_hello

class TestMyProject(unittest.TestCase):
    def test_say_hello(self):
        self.assertEqual(say_hello(), "Hello World!")

if __name__ == '__main__':
    unittest.main()
