PROJECT = myproject

VENV=.venv
PYTHON=$(VENV)/bin/python
PIP=$(VENV)/bin/pip
WHEEL=dist/*.whl
DEFAULT_CFG=default-cfg
SRC_DIR=myproject
ENTRYPOINT=$(VENV)/bin/hello

.PHONY: all
all: install

.PHONY: help
help:
	@echo "help: display this help"
	@echo "build: build the package"
	@echo "install: install the package in the virtual environment"
	@echo "uninstall: uninstall the package in the virtual environment"
	@echo "test: run the tests"
	@echo "version: update the version (for maintainers only)"
	@echo "venv: create a virtual environment for testing purposes"
	@echo "clean: clean build artifacts (__pycache__, pyc, ... but not the virtual environment) and uninstall the package in the virtual environment"
	@echo "clean-venv|clean-env|cleanvenv|cleanenv: delete the virtual environment"
	@echo "clean-all|cleanall: delete build artifacts and the virtual environment"

.PHONY: install
install: $(WHEEL)
	$(PIP) install $(WHEEL)

.PHONY: uninstall
uninstall:
	$(PIP) uninstall $(PROJECT)

.PHONY: uninstall-forcibly
uninstall-forcibly:
	yes | $(PIP) uninstall $(PROJECT)

$(WHEEL): dist

.PHONY: test
test: test-package

.PHONY: test-package
test-package:
	$(ENTRYPOINT) && $(ENTRYPOINT) $(USER)

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
	-rm -rf build dist $(PROJECT).egg-info

.PHONY: cleanenv clean-env cleanvenv clean-venv
cleanenv clean-env cleanvenv clean-venv:
	-rm -rf $(VENV) .env

.PHONY: cleanall clean-all
cleanall clean-all: clean clean-venv
