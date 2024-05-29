# homelab

### Run

```sh
mkvirtualenv homelab # or: workon homelab
pip install -r requirements.txt
ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault
```

You will need the file `vault` containing the Vault password. Get it from 1Password under "Homelab Ansible Vault".


### Notes

Specific roles can be run using `--tags`.

#### SSL
Services on the `allison-rpi.local` domain are secured with self-signed certificates. For these certificates to be trusted on the network, clients should add the reverse proxy's root certificate to their trust stores. On OSX, do this over HTTP in one line:

```sh
curl -sk https://allison-rpi.local/certs/root.crt -o /tmp/caddy-root.crt && sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/caddy-root.crt
```

#### Profiling Ansible slowness

Add `profile_tasks` to the comma-separated list under `[defaults] > callbacks_enabled`, then run a playbook. Timing of tasks will be output.
