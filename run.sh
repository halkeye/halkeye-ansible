which pip || sudo apt install python-pip python virtualenv libssl-dev -y
test -e venv || virtualenv venv
source venv/bin/activate
which ansible || pip install ansible
ansible-playbook -i "localhost," -c local $(hostname).yml  -K -b $@
