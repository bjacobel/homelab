# rpi

Ansible playbook to setup my Raspberry Pi. Currently includes:
  * homebridge
  * caddy
  * pi-hole
  * automated backups for data volumes

### Run

```sh
mkvirtualenv rpi # or: workon rpi
pip install -r requirements.txt
ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault
```

You will need the file `vault` containing the Vault password. Get it from 1Password under "rpi Ansible Vault."

### Assumptions
* pi is running raspbian
* host machine has installed `sshpass` (`brew install hudochenkov/sshpass/sshpass` if macOS)
* host machine has an ssh pubkey at `~/.ssh/id_rsa.pub`
* the UDM has been configured with [udm-utilities](https://github.com/boostchicken/udm-utilities) `on-boot-script` and `container-common`
* the UDM has the mDNS reflector installed and running with podman

### Notes
Easily get the IP of the pi:

```sh
arp -na | awk '/b8:27:eb/ {print $2}' | tr -d '()'
```

If using a pi 4 B, use 'dc:a6:32' for the MAC prefix.
