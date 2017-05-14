source venv/bin/activate
ansible-playbook -i "localhost," -c local $(hostname).yml  -K -b $@
