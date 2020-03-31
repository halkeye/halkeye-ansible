#!/bin/bash
source venv/bin/activate
PLAYBOOK=$1
shift
ansible-playbook -i inventory $PLAYBOOK --ask-become-pass --vault-password-file .vault -b $@
