#!/bin/bash
source venv/bin/activate
ansible -i inventory -l $(hostname) -c local $(hostname) --vault-password-file .vault -b -m setup
