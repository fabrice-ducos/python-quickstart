#!.venv/bin/python

import sys

# uncomment this in order to use dotenv (environment variables defined in the .env file); remove it otherwise.
#from dotenv import load_dotenv

def say_hello(name = None):
  if (name is None): name = "World!"
  return "Hello {}".format(name)

def main():
   argv = sys.argv
   if (len(argv) < 2):
     print(say_hello())
   else:
     name = argv[1]
     print(say_hello(name))

if __name__ == '__main__':
    main()
