import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_kubectl_krew(host):
    cmd = host.run("/usr/local/bin/kubectl krew version")

    assert cmd.rc == 0
