# homelab

Ansible playbook to setup my homelab. (Current tenancy is one Lenovo ThinkCentre m710 Tiny.) Currently includes:
  * Home automation/customization
    * [Homebridge](https://homebridge.io/)
    * [Pi-hole](https://pi-hole.net/)
    * [pihole-exporter](https://github.com/eko/pihole-exporter)
  * Monitoring/analytics
    * [CAdvisor](https://github.com/google/cadvisor)
    * [UniFi Poller](https://unpoller.com/)
    * [VictoriaMetrics vmagent](https://docs.victoriametrics.com/vmagent.html)
    * [Prometheus node-exporter](https://github.com/prometheus/node_exporter)
    * [Promtail](https://grafana.com/docs/loki/latest/clients/promtail/)
  * Security/management
    * [Authelia](https://authelia.com)
    * [TightVNC](https://www.tightvnc.com/)
    * [Wireguard](https://www.wireguard.com/)
  * Misc
    * [Caddy](https://caddyserver.com/)
    * [Redis](https://redis.io)
    * [Automated backups for data volumes](https://github.com/offen/docker-volume-backup)

Future plans include:
  * Prometheus
  * Prometheus Pushgateway
  * Loki
  * Grafana
  * Node-RED

### Run

```sh
mkvirtualenv homelab # or: workon homelab
pip install -r requirements.txt
ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault
```

You will need the file `vault` containing the Vault password. Get it from 1Password under "Homelab Ansible Vault".

### Assumptions
* The tenant is running Debian Bullseye with an XFCE GUI
* The tenant has been configured with `password` as the root password (will be overwritten)
* The tenant has been configured with a user `debian` with password `password` (will be removed)
* The tenant has an SSH server, and the user `debian` can SSH
* The user `debian` is in sudoers
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
Easily get the IP of the ThinkCentre, no matter what DHCP has done to it:

```sh
arp -na | awk '/6c:4b:90/ {print $2}' | tr -d '()'
```

The hardware is also bound to a static IP 192.168.1.72 in the UniFi interface.

#### SSL
Services on the `lab.local` domain are secured with self-signed certificates. For these certificates to be trusted on the network, clients should add the reverse proxy's root certificate to their trust stores. On OSX, do this over HTTP in one line:

```sh
curl -sk https://lab.local/certs/root.crt -o /tmp/caddy-root.crt && sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/caddy-root.crt
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

This may not work anymore; things have diverged a little bit. This was basically just for a sandbox so I didn't brick the ThinkCentre too many times.
