#!make
SHELL = /bin/bash
.DEFAULT_GOAL := run

ANSIBLE_PLAYBOOK := ansible-playbook -i inventory --vault-password-file .vault -l $$(hostname) -c local
ANSIBLE_DEBUG :=
PLAYBOOK := main

venv: venv/bin/activate ## Build virtual environment

venv/bin/activate: requirements.txt
	if [ ! -d venv ]; then \
	    virtualenv -p $(PYTHON_EXE) venv; \
			which pip3 || sudo apt install -y python3-pip python3-dev python3 libssl-dev build-essential git \
			which virtualenv || sudo pip3 install virtualenv \
			which unzip || sudo apt install -y unzip \
			which zip || sudo apt install -y zip \
			. venv/bin/activate; \
	fi
	. venv/bin/activate; pip install -U pip; pip install -r requirements.txt

deps: venv requirements.yml ## Install ansible dependancies
	. venv/bin/activate; ansible-galaxy install -r requirements.yml

.PHONY: clean
clean: ## Delete all generated artefacts
	$(RM) -rf venv
	find . -name "*.pyc" -exec $(RM) -rf {} \;

.PHONY: sync
sync: ## Synchronize ansible data
	git pull --rebase

.PHONY: run
run: deps ## Run
	. venv/bin/activate; $(ANSIBLE_PLAYBOOK) $(PLAYBOOK).yml $(ANSIBLE_DEBUG)

.PHONY: check
check: venv deps ## Validate all the configs
	. venv/bin/activate; $(ANSIBLE_PLAYBOOK) $(PLAYBOOK).yml $(ANSIBLE_DEBUG) --check --diff

.PHONY: lint
lint: venv ## Perform an ansible-lint linting
	. venv/bin/activate; ansible-lint main.yml

.PHONY: vars
vars: venv ## List all variables
	. venv/bin/activate; ansible $$(hostname) --vault-password-file .vault -c local -m ansible.builtin.setup

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
