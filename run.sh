source venv/bin/activate
ansible-playbook -i inventory -l $(hostname) -c local main.yml  -K -b $@
