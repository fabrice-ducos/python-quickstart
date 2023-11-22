# python-minimal-package

This project contains a kickstarter for starting a Python project.

## How to start

1. Clone the project:
  - by ssh:   `git clone git@gitlab-ssh.univ-lille.fr:fabrice.ducos/python-minimal-package.git your-project-name`
  - by https: `git clone https://gitlab.univ-lille.fr/fabrice.ducos/python-minimal-package.git your-project-name`

2. Build and test the project:
  `cd your-project-name`

3. Replace *myproject* with *your-project-name* everywhere in the three following files: setup.cfg, Makefile and pyproject.toml

4. In pyproject.toml, change the author's name, the email, and any other relevant information (e.g. classifiers, entry points) for the project

5. Rename the `myproject` directory with the name `your-project-name`

6. Build and test the package: `make && make test`

7. If it works, add environment variables in the .env file (without export or setenv), and dependencies in requirements.txt

8. Clean, build and test again: `make clean && make && make test`

9. If it still works, congratulations: you are ready to go.

The steps 3 to 5 should be automated in a future version of the project.

