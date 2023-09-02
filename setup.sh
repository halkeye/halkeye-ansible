#!/bin/bash
set -euf -o pipefail
which pip3 || sudo apt install -y python3-pip python3-dev python3 libssl-dev build-essential git
which virtualenv || sudo pip3 install virtualenv
which unzip || sudo apt install -y unzip
which zip || sudo apt install -y zip
test -e venv || virtualenv venv
source venv/bin/activate
which ansible || pip install ansible
