# homelab

Ansible playbook to setup my homelab. (Current tenancy is one Raspberry Pi Model B rev. 2.) Currently includes:
  * homebridge
  * caddy
  * pi-hole
  * automated backups for data volumes

### Run

```sh
mkvirtualenv homelab # or: workon homelab
pip install -r requirements.txt
ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault
```

You will need the file `vault` containing the Vault password. Get it from 1Password under "Homelab Ansible Vault".

### Assumptions
* tenant is running raspbian
* host machine has installed `sshpass` (`brew install hudochenkov/sshpass/sshpass` if macOS)
* host machine has an ssh pubkey at `~/.ssh/id_rsa.pub`
* the UDM has been configured with [udm-utilities](https://github.com/boostchicken/udm-utilities) `on-boot-script-2.x`, `cni-plugins` and `container-common`
  * Other optional current UDM config: `ddns-route53`, `ssh-keys` (this is not configured here)

### Notes
Easily get the IP of the Raspberry PI:

```sh
arp -na | awk '/b8:27:eb/ {print $2}' | tr -d '()'
```

This will need to be updated when the new hardware arrives.

### SSL
Services on the `.local` domain are secured with self-signed certificates. For these certificates to be trusted on the network, clients should add the reverse proxy's root certificate to their trust stores. On OSX, do this over HTTP in one line:

    curl -sk https://pi.local/certs/root.crt -o /tmp/caddy-root.crt && sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/caddy-root.crt

