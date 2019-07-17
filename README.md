# skyhook-popper

## Installation
1. Install:
  - git
  - docker
  - base64
  - popper
2. Setup your CloudLab environment variables.
3. `git clone https://github.com/KDahlgren/skyhook-popper.git`
4. `cd skyhook-popper`
5. `popper run`


## Setting Up CloudLab Environment Variables
Running popper on CloudLab requires specifying a number of environment variables local to the machine executing the `popper run` command.

| Variables | Description |
|---|---|
| ANSIBLE_SSH_KEY_DATA | Allows the machines in the cluster to communicate (piped through base64) |
| GENI_PROJECT | The name of the project requesting resources (in plain text) |
| GENI_USERNAME | Your CloudLab username (piped through base64) |
| GENI_PASSWORD | Your CloudLab password (in plain text) |
| GENI_PUBKEY_DATA | The public key used to ssh between your machine and CloudLab (through base64) |
| GENI_CERT_DATA | Your CloudLab pem file (through base64) |
| GENI_KEY_PASSPHRASE | Your password again (in plain text) |

**Example Lines in Bash:**
```
export ANSIBLE_SSH_KEY_DATA=$(cat ~/.ssh/cloudlab_kat \| base64) ;
export GENI_PROJECT='Skyhook' ;
export GENI_USERNAME=$(cat ~/popper_stuff/geni_username.txt \| base64) ;
export GENI_PASSWORD='<insert your cloudlab password here>' ; #yeah it feels weird =\
export GENI_PUBKEY_DATA=$(cat ~/.ssh/cloudlab_kat.pub \| base64) ;
export GENI_CERT_DATA=$(cat ~/.ssh/cloudlab.pem \| base64) ; #you get this from cloudlab when you sign up
export GENI_KEY_PASSPHRASE='<insert your cloudlab password here>' ; #yes...you're inputting it again.
```
