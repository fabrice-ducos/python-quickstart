PROJECT = myproject

VENV=.venv
PYTHON=$(VENV)/bin/python
PIP=$(VENV)/bin/pip
TESTRUNNER=$(PYTHON) -m unittest
WHEEL=dist/*.whl
DEFAULT_CFG=default-cfg
SRC_DIR=myproject
TEST_DIR=tests
ENTRYPOINT=$(VENV)/bin/main
INIT_SCRIPT=./.init.sh

.PHONY: all
all: install

.PHONY: help
help:
	@echo "help: display this help"
	@echo "dev|run-dev|start-dev: run the package in development mode, from the source directory"
	@echo "init: initialize the project"
	@echo "build: build the package"
	@echo "install: install the package in the virtual environment"
	@echo "uninstall: uninstall the package in the virtual environment"
	@echo "run|start: run the package"
	@echo "test|tests: run all the tests"
	@echo "utest|unit-test: run the unit tests"
	@echo "e2e|e2e-test|e2e-tests: run end-to-end tests"
	@echo "test-package: test the package (the wheel file)"
	@echo "version: update the version (for maintainers only)"
	@echo "clean: clean build artifacts (__pycache__, pyc, ... but not the virtual environment) and uninstall the package in the virtual environment"
	@echo "clean-venv|clean-env|cleanvenv|cleanenv: delete the virtual environment"
	@echo "clean-all|cleanall: delete build artifacts and the virtual environment"

.PHONY: install
install: $(WHEEL)
	$(PIP) install $(WHEEL)

.PHONY: uninstall
uninstall:
	-$(PIP) uninstall $(PROJECT)

.PHONY: uninstall-forcibly
uninstall-forcibly:
	-yes | $(PIP) uninstall $(PROJECT)

.PHONY: init
init: $(INIT_SCRIPT)
	$(INIT_SCRIPT) && rm -i $(INIT_SCRIPT)

$(INIT_SCRIPT):
	@echo "The initialization script $(INIT_SCRIPT) could not be found. Either the project was already initialized, or the script was deleted erroneously." ; \
	echo "If you do need the script, you can get a copy at https://gitlab.univ-lille.fr/fabrice.ducos/python-minimal-package" && false

$(WHEEL): dist

$(ENTRYPOINT):
	$(MAKE) install

.PHONY: run start
run start: $(ENTRYPOINT)
	$(ENTRYPOINT)

.PHONY: dev run-dev start-dev
dev run-dev start-dev: $(ENTRYPOINT)
	$(SRC_DIR)/main.py

.PHONY: test tests
test tests: unit-tests e2e-tests test-package

.PHONY: e2e e2e-test e2e-tests
e2e e2e-test e2e-tests:
	@echo "No end-to-end test"

.PHONY: test-package
test-package:
	$(ENTRYPOINT) && $(ENTRYPOINT) $(USER)

# syntax: for a file tests/tests_module_name.py, use $(TESTRUNNER) tests.tests_module_name (without the extension)
.PHONY: unit-test unit-tests utest
unit-test unit-tests utest:
	$(TESTRUNNER) tests.tests

dist: $(VENV)
	$(PIP) install build && $(PYTHON) -m build

$(VENV): .env
	python3 -m venv $(VENV) && source $(VENV)/bin/activate && $(PIP) install --upgrade pip && $(PIP) install -r requirements.txt 

# configuration file containing environment variables (recognized by the Python dotenv module)
.env:
	cp $(DEFAULT_CFG)/dotenv.dist .env

.PHONY: tag version
tag version:
	@echo "New version (form x.y.z)? " && read version && sed -e "s/__project__/$(PROJECT)/;s/__version__/$$version/" setup.cfg.template > setup.cfg && echo "git add setup.cfg && git commit -m 'Version set to $$version' && git tag v$$version && git push && git push --tag" 

.PHONY: clean
clean: uninstall-forcibly
	-find $(SRC_DIR) -name '__pycache__' | xargs -I {} rm -rfv {}
	-find $(SRC_DIR) -name '*~' | xargs -I {} rm -rfv {}
	-find $(SRC_DIR) -name '*.pyc' | xargs -I {} rm -rfv {}
	-find $(SRC_DIR) -name '*.egg-info' | xargs -I {} rm -rfv {}
	-find $(TEST_DIR) -name '__pycache__' | xargs -I {} rm -rfv {}
	-find $(TEST_DIR) -name '*~' | xargs -I {} rm -rfv {}
	-find $(TEST_DIR) -name '*.pyc' | xargs -I {} rm -rfv {}
	-find $(TEST_DIR) -name '*.egg-info' | xargs -I {} rm -rfv {}
	-rm -rf build dist $(PROJECT).egg-info

.PHONY: cleanenv clean-env cleanvenv clean-venv
cleanenv clean-env cleanvenv clean-venv:
	-rm -rf $(VENV) .env

.PHONY: cleanall clean-all
cleanall clean-all: clean clean-venv
