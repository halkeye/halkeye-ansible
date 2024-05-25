#!make
SHELL = /bin/bash
.DEFAULT_GOAL := run

PY=/usr/bin/python3
ANSIBLE_PLAYBOOK ?= $(VENV)/ansible-playbook -i inventory --vault-password-file .vault -l $$(hostname) -c local
ANSIBLE_DEBUG :=
PLAYBOOK := main

#venv: venv/bin/activate ## Build virtual environment
#(which pip3 || sudo apt install -y python3-pip python3-dev python3 libssl-dev build-essential git) && \
#(which virtualenv || sudo pip3 install virtualenv) && \

requirements.yml: venv
	$(VENV)/ansible-galaxy install -r requirements.yml --force

.PHONY: clean
clean: clean-venv ## Delete all generated artefacts
	find . -name "*.pyc" -exec $(RM) -rf {} \;

.PHONY: setup
setup: venv requirements.yml ## Installs minimal dependancies
	(which unzip || sudo apt install -y unzip) && \
	(which zip || sudo apt install -y zip)

.PHONY: sync
sync: ## Synchronize ansible data
	git pull --rebase

.PHONY: run
run: setup ## Run
	$(ANSIBLE_PLAYBOOK) $(PLAYBOOK).yml $(ANSIBLE_DEBUG)

.PHONY: lint
lint: setup ## Perform an ansible-lint linting
	$(VENV)/ansible-lint main.yml

.PHONY: vars
vars: setup ## List all variables
	$(VENV)/ansible $$(hostname) --vault-password-file .vault -c local -m ansible.builtin.setup

.PHONY: debug
debug: ANSIBLE_DEBUG+=-vvv
debug: run ## Run in debug mode

.PHONY: software
software: ANSIBLE_DEBUG+=-t software
software: run ## Just update software

.PHONY: git
git: ANSIBLE_DEBUG+=-t git
git: run ## Just update git

.PHONY: vim
vim: ANSIBLE_DEBUG+=-t vim
vim: run ## Just update vim

.PHONY: go
go: ANSIBLE_DEBUG+=-t go
go: run ## Just update go

.PHONY: diff
diff: ANSIBLE_DEBUG+=--check --diff
diff: run ## Dry run and output diffs not run

.PHONY: check
check: diff

.PHONY: asdf-defaults
asdf-defaults: venv  ## Install default modules when asdf wasn't installed right
	cat $(HOME)/.default-npm-packages | xargs $(HOME)/.asdf/shims/npm install -g
	$(HOME)/.asdf/shims/pip install -r $(HOME)/.default-python-packages
	$(VENV)/pip install -r $(HOME)/.default-python-packages
	cat $(HOME)/.default-gems | xargs -n1 $(HOME)/.asdf/shims/gem install
	cat $(HOME)/.default-perl-modules | xargs -n1 $(HOME)/.asdf/shims/cpanm

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2023.04.17/Makefile.venv"
	echo "fb48375ed1fd19e41e0cdcf51a4a0c6d1010dfe03b672ffc4c26a91878544f82 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv

