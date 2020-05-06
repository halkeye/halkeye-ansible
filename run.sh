#!/bin/bash
source venv/bin/activate
if [ -e "/usr/local/opt/gnu-tar/libexec/gnubin" ]; then export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"; fi

ansible-playbook -i inventory -l $(hostname) -c local main.yml --ask-become-pass --vault-password-file .vault -b $@
