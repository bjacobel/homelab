Vagrant.configure("2") do |config|
  config.vm.box = "perk/debian-11-genericcloud-arm64"
  config.vm.box_version = "20230124-1270"

  # allows a passwordless login as the first_time_user
  config.ssh.insert_key = true

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.extra_vars = { ansible_user_first_run: "vagrant", inventory_hostname: "homelab" }
    ansible.vault_password_file="./vault"
    ansible.playbook = "./playbook.yml"
  end
end
