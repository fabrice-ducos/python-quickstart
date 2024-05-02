PROJECT = myproject

VENV=.venv
PYTHON := python3
PIP := pip3
PYTHON_VERSION = $(shell $(PYTHON) --version | cut -d' ' -f 2)
MIN_PYTHON_VERSION = 3.11
VENV_PYTHON=$(VENV)/bin/python
VENV_PIP=$(VENV)/bin/pip
TESTRUNNER=$(VENV_PYTHON) -m unittest
WHEEL=dist/*.whl
DEFAULT_CFG=default-cfg
SRC_DIR=myproject
TEST_DIR=tests
ENTRYPOINT=$(VENV)/bin/main
INIT_SCRIPT=./.init.sh

# solution credited to @yairchu at https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash
define_version := version() { \
  echo "$$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $$1,$$2,$$3,$$4); }'; \
} 

.PHONY: all
all: install-in-venv

.PHONY: help
help:
	@echo "help: display this help"
	@echo "dev|run-dev|start-dev|launch-dev: run the package in development mode, from the source directory"
	@echo "init: initialize the project"
	@echo "build: build the package"
	@echo "install: install in the host environment (not implemented yet)"
	@echo "uninstall: uninstall from the host environment, when possible (not implemented yet)"
	@echo "install-in-venv: install the package in the virtual environment (is usually done automatically by make)"
	@echo "uninstall-from-venv: uninstall the package in the virtual environment"
	@echo "run|start|launch: run the package"
	@echo "test|tests: run all the tests"
	@echo "utest|unit-test: run the unit tests"
	@echo "e2e|e2e-test|e2e-tests: run end-to-end tests"
	@echo "test-package: test the package (the wheel file)"
	@echo "version: update the version (for maintainers only)"
	@echo "clean: clean build artifacts (__pycache__, pyc, ... but not the virtual environment) and uninstall the package in the virtual environment"
	@echo "clean-venv|clean-env|cleanvenv|cleanenv: delete the virtual environment"
	@echo "clean-all|cleanall: delete build artifacts and the virtual environment"
	@echo
	@echo "PYTHON: $(PYTHON)"
	@echo "Detected version of PYTHON: $(PYTHON_VERSION)"

.PHONY: install-in-venv
install-in-venv: $(WHEEL)
	$(VENV_PIP) install $(WHEEL)

.PHONY: uninstall-fron-venv
uninstall-from-venv:
	-$(VENV_PIP) uninstall $(PROJECT)

.PHONY: uninstall-forcibly
uninstall-forcibly:
	-yes | $(VENV_PIP) uninstall $(PROJECT)

.PHONY: init
init: $(INIT_SCRIPT)
	$(INIT_SCRIPT) && cp $(INIT_SCRIPT) $(INIT_SCRIPT).bak

$(INIT_SCRIPT): $(INIT_SCRIPT).orig
	cp $(INIT_SCRIPT).orig $(INIT_SCRIPT)

$(INIT_SCRIPT).orig:
	@echo "The initialization script $(INIT_SCRIPT).orig could not be found. Maybe it was deleted erroneously." ; \
	echo "If you do need the script, you can get a copy at https://github.com/fabrice-ducos/python-quickstart" && false

$(WHEEL): dist

$(ENTRYPOINT):
	$(MAKE) install

.PHONY: run start
run starti launch: $(ENTRYPOINT)
	$(ENTRYPOINT)

.PHONY: dev run-dev start-dev
dev run-dev start-dev launch-dev: $(ENTRYPOINT)
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
	$(VENV_PIP) install build && $(VENV_PYTHON) -m build

$(VENV): check-python .env
	$(PYTHON) -m venv $(VENV) && $(VENV_PIP) install --upgrade pip && $(VENV_PIP) install -r requirements.txt 

.PHONY: check-python
check-python:
	@$(define_version) && if [ $$(version "$(PYTHON_VERSION)") -lt $$(version "$(MIN_PYTHON_VERSION)") ]; then echo "Python version $(PYTHON_VERSION) is too old. Please use at least $(MIN_PYTHON_VERSION). You can use: make PYTHON=/path/to/python in order to set a proper Python interpreter." 1>&2; exit 1; fi

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
