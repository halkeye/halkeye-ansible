#!/bin/bash
source .venv/bin/activate
ansible-inventory -i inventory --vault-password-file .vault $@
