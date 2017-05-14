which pip || sudo apt install python-pip python virtualenv libssl-dev -y
test -e venv || virtualenv venv
source venv/bin/activate
which ansible || pip install ansible
ansible-galaxy install -p ./roles -r requirements.yml
