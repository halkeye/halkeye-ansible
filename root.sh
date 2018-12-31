#!/bin/bash
source venv/bin/activate
ansible-playbook -i inventory -l $(hostname) -c local root.yml --ask-become-pass --vault-password-file .vault -b $@
