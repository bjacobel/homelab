# homelab

Ansible playbook to setup my homelab. (Current tenancy is one Raspberry Pi Model B rev. 2.) Currently includes:
  * Homebridge
  * Caddy
  * Pi-hole
  * Unifi-poller
  * VictoriaMetrics vmagent
  * CAdvisor
  * Prometheus node-exporter
  * Automated backups for data volumes

Future plans include:
  * Prometheus
  * Prometheus Pushgateway
  * Grafana
  * WireGuard
  * Node-RED

### Run

```sh
mkvirtualenv homelab # or: workon homelab
pip install -r requirements.txt
ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault
```

You will need the file `vault` containing the Vault password. Get it from 1Password under "Homelab Ansible Vault".

### Assumptions
* The tenant is running Debian Bullseye (or Raspbian)
* The tenant has been configured with a default user/password and an SSH server
* The host machine has installed `sshpass` (`brew install hudochenkov/sshpass/sshpass` if macOS)
* The host machine has an ssh pubkey at `~/.ssh/id_rsa.pub`
* The network is behind a UDM
* The UDM has been configured with [udm-utilities](https://github.com/boostchicken/udm-utilities) `on-boot-script-2.x`, `cni-plugins` and `container-common`
  * Other optional current UDM config: `ddns-route53`, `ssh-keys` (this is not configured here)

### Notes

#### Structure
* `base`: Sets up basic Debian stuff; SSH, hostname, shell customization
* `docker`: Installs a recent Docker and boots it
* `compose`: Installs Docker Compose and templates a Compose file. Services that can be configured purely with environment variables live here.
* **Non-environment configuration**: Services that need configuration files or management files have separate roles called by the Compose role. Includes:
  * `caddy`
  * `pihole`
  * `homebridge`
  * `vmagent`

Specific roles can be run using `--tags`.

#### Hosts
Easily get the IP of the Raspberry PI, no matter what DHCP has done to it:

```sh
arp -na | awk '/b8:27:eb/ {print $2}' | tr -d '()'
```

This will need to be updated when the new hardware arrives.

#### SSL
Services on the `.local` domain are secured with self-signed certificates. For these certificates to be trusted on the network, clients should add the reverse proxy's root certificate to their trust stores. On OSX, do this over HTTP in one line:

```sh
curl -sk https://pi.local/certs/root.crt -o /tmp/caddy-root.crt && sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/caddy-root.crt
```

#### Vagrant
There's a Vagrantfile for testing the Ansible playbooks. It only works on an ARM Mac. Follow [the instructions here](https://plugin-activation.hashicorp.com/perk/boxes/debian-11-genericcloud-arm64) and then run:

```
vagrant destroy -f && killsof 50022 && vagrant up --provider=qemu && vagrant provision
```

To SSH into the vagrant box under the intended user to scope stuff out, run:

```
ssh bjacobel@127.0.0.1 -p 50022  -o PreferredAuthentications=publickey -o PubkeyAuthentication=yes -o StrictHostKeyChecking=no
```
