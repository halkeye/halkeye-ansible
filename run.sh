#!/bin/bash
source venv/bin/activate
ansible-playbook -i inventory -l $(hostname) -c local main.yml --ask-become-pass --vault-password-file .vault -b $@
