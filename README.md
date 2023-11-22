# python-minimal-package

This project contains a kickstarter for starting a Python project.

## How to start

1. Clone the project:
  - by ssh:   `git clone git@gitlab-ssh.univ-lille.fr:fabrice.ducos/python-minimal-package.git your-project-name`
  - by https: `git clone https://gitlab.univ-lille.fr/fabrice.ducos/python-minimal-package.git your-project-name`

2. Build and test the project:
  `cd your-project-name`

3. Initialize the project:
  `make init`

4. In pyproject.toml, change the author's name, the email, and any other relevant information (e.g. classifiers, entry points) for the project

5. Build and test the package: `make && make test`

6. If it works, add environment variables in the .env file (without export or setenv), and dependencies in requirements.txt

7. Clean, build and test again: `make clean && make && make test`

8. If it still works, congratulations: you are ready to go.

