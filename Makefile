#!make
.DEFAULT_GOAL := run

ANSIBLE_PLAYBOOK := ~/.local/bin/ansible-playbook -i inventory --vault-password-file .vault -l $$(hostname) -c local
ANSIBLE_DEBUG :=
PLAYBOOK := main

deps: requirements.yml ## Install ansible dependancies
	~/.local/bin/ansible-galaxy install -r requirements.yml

.PHONY: run
run: deps ## Run
	$(ANSIBLE_PLAYBOOK) $(PLAYBOOK).yml $(ANSIBLE_DEBUG)

.PHONY: check
check: deps ## Validate all the configs
	$(ANSIBLE_PLAYBOOK) $(PLAYBOOK).yml $(ANSIBLE_DEBUG) --check --diff

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
