workflow "run test" {
  on = "push"
  resolves = "teardown 4osds"
}

action "build context" {
  uses = "popperized/geni/build-context@master"
  env = {
    GENI_FRAMEWORK = "cloudlab"
  }
  secrets = [
    "GENI_PROJECT",
    "GENI_USERNAME",
    "GENI_PASSWORD",
    "GENI_PUBKEY_DATA",
    "GENI_CERT_DATA"
  ]
}

action "request resources 4osds" {
  needs = "build context"
  uses = "popperized/geni/exec@master"
  args = "geni/request_4.py"
  secrets = ["GENI_KEY_PASSPHRASE"]
}

action "run experiments 4osds" {
  needs = "request resources 4osds"
  uses = "popperized/ansible@master"
  args = [
    "-i", "geni/hosts.ini",
    "lib/skyhook-ansible/ansible/setup_playbook.yml"
  ]
  env = {
    ANSIBLE_HOST_KEY_CHECKING = "False"
  }
  secrets = ["ANSIBLE_SSH_KEY_DATA"]
}

action "teardown 4osds" {
  needs = "run experiments 4osds"
  uses = "popperized/geni/exec@master"
  args = "geni/release.py"
  secrets = ["GENI_KEY_PASSPHRASE"]
}

#action "request resources 8osds" {
#  needs = "build context"
#  uses = "popperized/geni/exec@master"
#  args = "geni/request_8.py"
#  secrets = ["GENI_KEY_PASSPHRASE"]
#}
#
#action "run experiments 8osds" {
#  needs = "request resources 8osds"
#  uses = "popperized/ansible@master"
#  args = [
#    "-i", "geni/hosts.ini",
#    "lib/skyhook-ansible/ansible/setup_playbook.yml"
#  ]
#  env = {
#    ANSIBLE_HOST_KEY_CHECKING = "False"
#  }
#  secrets = ["ANSIBLE_SSH_KEY_DATA"]
#}
#
#action "teardown 8osds" {
#  needs = "run experiments 8osds"
#  uses = "popperized/geni/exec@master"
#  args = "geni/release.py"
#  secrets = ["GENI_KEY_PASSPHRASE"]
#}
