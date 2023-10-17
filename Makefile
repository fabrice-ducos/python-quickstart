PROJECT = myproject

PYTHON=python3
PIP=pip3

.PHONY: all
all: build

.PHONY: help
help:
	@echo "help: display this help"
	@echo "build: build the package"
	@echo "install: install the package"
	@echo "version: update the version (for maintainers only)"
	@echo "clean: clean build artifacts"

.PHONY: build
build:
	$(PIP) install build && $(PYTHON) -m build

.PHONY: install
install:
	$(PYTHON) setup.py install

.PHONY: tag version
tag version:
	@echo "New version (form x.y.z)? " && read version && sed -e "s/__version__/$$version/" setup.cfg.template > setup.cfg && echo "git add setup.cfg && git commit -m 'Version set to $$version' && git tag v$$version && git push && git push --tag" 

.PHONY: clean
clean:
	-rm -f *~
	-rm -rf __pycache__ *.pyc
	-rm -rf build dist $(PROJECT).egg-info


