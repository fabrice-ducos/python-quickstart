# python-quickstart

This project provides a starter kit for a Python project, providing a default but minimal framework
for packaging an application, relieving the developer from this tedious task.

For the user, it provides a common way to build and launch the application, irrespective to the language (here, Python).

When deploying the project, the user should only have to type `make` in order to build the project, and `make run` or `make start` (these are synonyms) for launching it.

## How to start (for developers)

1. Clone the project:
  - by ssh:   `git clone git@github.com:fabrice-ducos/python-quickstart.git your-project-name`
  - by https: `git clone https://github.com/fabrice-ducos/python-quickstart.git your-project-name`

2. Build and test the project:
  `cd your-project-name`

3. Initialize the project:
  `make init`
  The name of the project, of its author and of the author's email (for commits) will be asked for.

4. In pyproject.toml, the name of the project and its author should be updated automatically by `make init`. Edit any other relevant information that you may identify (e.g. classifiers, entry points).

5. Build and test the package: `make && make test`

6. If it works, add any relevant environment variables in the .env file (without export or setenv), and dependencies in requirements.txt

7. Clean, build and test again: `make clean && make && make test`

8. If it still works, congratulations: the developer is .
Otherwise, return to step 6.

## How to start (for users)

1. Build the project with `make` (will automatically install all the dependencies declared in requirements.txt in a virtual environment)

2. Launch the tests with `make test`

3. Launch the project with `make run`, `make start` or `make launch` (these are synonyms)

## Warnings and limitations

* It is still a work in progress and may not be adapted to all use cases.
* Windows operating systems are not yet supported

