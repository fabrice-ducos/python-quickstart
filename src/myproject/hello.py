#!.venv/bin/python

import sys

# uncomment this in order to use dotenv (environment variables defined in the .env file); remove it otherwise.
#from dotenv import load_dotenv

def say_hello(name = None):
  if (name is None): name = "World!"
  print("Hello {}".format(name))

def main():
   argv = sys.argv
   if (len(argv) < 2):
     say_hello()
   else:
     name = argv[1]
     say_hello(name)

if __name__ == '__main__':
    main()
