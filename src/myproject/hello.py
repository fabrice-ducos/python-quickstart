#!.venv/bin/python

# uncomment this in order to use dotenv (environment variables defined in the .env file); remove it otherwise.
#from dotenv import load_dotenv

def say_hello(name = None):
  if (name is None): name = "World!"
  print("Hello {}".format(name))

if __name__ == '__main__':
    say_hello()
