#!/bin/bash
which pip3 || sudo apt install python-pip python-dev python libssl-dev build-essential -y
which virtualenv || sudo pip3 install virtualenv
test -e venv || virtualenv venv
source venv/bin/activate
which ansible || pip install ansible
ansible-galaxy install -p ./roles -r requirements.yml --force
