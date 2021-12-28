# rpi

Ansible playbook to setup my Raspberry Pi. Currently includes:
  * homebridge
  * caddy
  * automated backups for data volumes

### Run

```sh
mkvirtualenv rpi # or: workon rpi
pip install -r requirements.txt
ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault
```

You will need the file `vault` containing the Vault password. Get it from 1Password under "rpi Ansible Vault."

### Assumptions
* pi exists at `pi.local`
* pi has ssh setup and knows our ssh key already
* pi has a `bjacobel` user
* the UDM has been configured with [udm-utilities](https://github.com/boostchicken/udm-utilities) `on-boot-script` and `container-common`
* the UDM has the mDNS reflector installed and running with podman
