# Makefile for etl-python-project
# Usage: make <target>

PY=python3
VENV=.venv
PIP=$(VENV)/bin/pip
PYTHON=$(VENV)/bin/python
REQ=requirements.txt

.PHONY: help venv install install-dev test run-api run-file run-db clean

help:
	@echo "Available targets:"
	@echo "  venv        		- create virtualenv in $(VENV)"
	@echo "  install     		- create venv (if missing) and install runtime dependencies"
	@echo "  install-dev	 	- install runtime + development extras (pytest, black)"
	@echo "  run-api     		- run ETL using API source (copy mode)"
	@echo "  run-api-upsert     	- run ETL using API source (upsert mode)"
	@echo "  generate-users		- generate sample users.csv file in data/ folder"
	@echo "  run-file    		- run ETL using file source (copy mode)"
	@echo "  run-file-upsert    	- run ETL using file source (upsert mode)"
	@echo "  run-db      		- run ETL using db source (copy mode)"
	@echo "  run-db-upsert     	- run ETL using db source (upsert mode)"
	@echo "  clean       		- remove .pyc, __pycache__ and virtualenv"

venv:
	@if [ ! -d "$(VENV)" ]; then \
		$(PY) -m venv $(VENV); \
		echo "Created virtualenv at $(VENV)"; \
	else \
		echo "Virtualenv $(VENV) already exists"; \
	fi

install: venv
	$(PIP) install --upgrade pip
	@if [ -f "$(REQ)" ]; then \
		$(PIP) install -r $(REQ); \
	else \
		$(PIP) install -e .; \
	fi
	@echo "Installed runtime dependencies."

install-dev: install
	# install development extras defined in pyproject (if any)
	$(PIP) install -e .[dev] || echo "Optional dev extras not installed (no extras or pip/setuptools limitations)."
	@echo "Installed dev dependencies (if available)."

run-api: venv
	@echo "Running ETL: source=api, load-mode=copy"
	$(PYTHON) -m src.main --source api --load-mode copy

run-api-upsert: venv
	@echo "Running ETL: source=api, load-mode=copy"
	$(PYTHON) -m src.main --source api --load-mode upsert

generate-users: venv
	@echo "Generating sample users.csv file with $(num_records) records."
	$(PYTHON) src/generateusers.py
	
run-file: venv
	@echo "Running ETL: source=file, load-mode=upsert"
	$(PYTHON) -m src.main --source file --load-mode copy

run-file-upsert: venv
	@echo "Running ETL: source=file, load-mode=upsert"
	$(PYTHON) -m src.main --source file --load-mode upsert

run-db: venv
	@echo "Running ETL: source=db, load-mode=copy"
	$(PYTHON) -m src.main --source db --load-mode copy

run-db-upsert: venv
	@echo "Running ETL: source=db, load-mode=copy"
	$(PYTHON) -m src.main --source db --load-mode upsert

clean:
	rm -rf $(VENV)
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -type f -delete 2>/dev/null || true
	@echo "Cleaned virtualenv and python artifacts."
