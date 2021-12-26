# rpi

Ansible playbook to setup my Raspberry Pi. Currently includes:
  * homebridge
  * caddy

### Run

```sh
mkvirtualenv rpi # or: workon rpi
pip install -r requirements.txt
ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault
```

### Assumptions
* pi exists at `pi.local`
* pi has ssh setup and knows our ssh key already
* pi has a `bjacobel` user
* pi has both ethernet and wifi on two different subnets
* the UDM has been configured with [udm-utilities](https://github.com/boostchicken/udm-utilities) `on-boot-script` and `container-common`
* the UDM has the mDNS reflector installed and running with podman
