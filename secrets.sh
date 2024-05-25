#!/bin/bash
source .venv/bin/activate
CMD=$1
shift
ansible-vault $CMD --vault-password-file .vault $@
