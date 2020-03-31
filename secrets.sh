#!/bin/bash
source venv/bin/activate
ansible-vault --vault-password-file .vault $@
