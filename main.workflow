workflow "run test" {
  on = "push"
  resolves = "teardown"
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

action "request resources" {
  needs = "build context"
  uses = "popperized/geni/exec@master"
  args = "geni/request.py"
  secrets = ["GENI_KEY_PASSPHRASE"]
}

action "run test" {
  needs = "request resources"
  uses = "popperized/ansible@master"
  args = [
    "-i", "geni/hosts",
    "ansible/playbook.yml"
  ]
  env = {
    ANSIBLE_HOST_KEY_CHECKING = "False"
  }
  secrets = ["ANSIBLE_SSH_KEY_DATA"]
}

action "teardown" {
  needs = "run test"
  uses = "popperized/geni/exec@master"
  args = "geni/release.py"
  secrets = ["GENI_KEY_PASSPHRASE"]
}
