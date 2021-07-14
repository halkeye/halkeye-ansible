#!/bin/bash
set -euf -o pipefail
which pip3 || sudo apt install python3-pip python3-dev python3 libssl-dev build-essential git -y
which virtualenv || sudo pip3 install virtualenv
test -e venv || virtualenv venv
source venv/bin/activate
which ansible || pip install ansible
ansible-galaxy install -p ./roles -r requirements.yml --force
