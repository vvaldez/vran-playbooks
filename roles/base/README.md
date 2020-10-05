# base

This role assumes the following has been done:

- The system is RHEL based
- Create user to use
- `ssh-copy-id` to that user
- That user has password less sudo access

```sh
useradd <username> -g wheel

cat /etc/sudoers
# %wheel ALL=(ALL) NOPASSWD: ALL

passwd <username>

ssh-copy-id <username>@example.com
```

This role will then:

- Set the hostname
- Set the timezone

- `yum update` (must set `-e update=yes`)
- Install various packages
- Install oh-my-zsh
- Install dotfiles
- Install pip
- Install pip-docker
- Install and enable docker daemon

- Disable root SSH access
- Disable password SSH authentication

# example

```sh
# Run yum update
ansible-playbook -i ../ansible-inventory/hosts-infra pb-setup-system.yml -e yum_update=yes --limit kvm

# Clear out existing and setup new nics
ansible-playbook -i ../ansible-inventory/hosts-infra pb-setup-system.yml -e setup_nics=yes --limit kvm

# Do not run yum update or setup nics
ansible-playbook -i ../ansible-inventory/hosts-infra pb-setup-system.yml --limit kvm
```
