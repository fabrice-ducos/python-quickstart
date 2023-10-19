PROJECT = myproject

PYTHON=python3
PIP=pip3
WHEEL=dist/*.whl
VENV=venv

.PHONY: all
all: dist

.PHONY: help
help:
	@echo "help: display this help"
	@echo "build: build the package"
	@echo "install: install the package"
	@echo "version: update the version (for maintainers only)"
	@echo "clean: clean build artifacts"
	@echo "venv: create a virtual environment for testing purposes"
	@echo "clean-venv: delete the virtual environment"

dist:
	$(PIP) install build && $(PYTHON) -m build

.PHONY: install
install: $(WHEEL)
	$(PIP) install $(WHEEL)

.PHONY: tag version
tag version:
	@echo "New version (form x.y.z)? " && read version && sed -e "s/__version__/$$version/" setup.cfg.template > setup.cfg && echo "git add setup.cfg && git commit -m 'Version set to $$version' && git tag v$$version && git push && git push --tag" 

.PHONY: clean
clean:
	-rm -f *~
	-rm -rf __pycache__ *.pyc
	-rm -rf build dist $(PROJECT).egg-info

$(VENV):
	$(PYTHON) -m venv $(VENV) && source $(VENV)/bin/activate && $(PIP) install --upgrade pip && $(PIP) install -r requirements.txt 

.PHONY: clean-venv
clean-venv:
	-rm -rf $(VENV)

