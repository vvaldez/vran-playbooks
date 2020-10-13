# Ansible Playbook: Install Ceph

This playbook will:

- Set system hostname
- Register to Satellite
- Install Ceph packages
- Configure firewall
- Setup OS networking

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/ceph/create/install_ceph.yml
```

## Requirements

This playbook has the following role requirements:

  - `linux-system-roles.network`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_automation_username` | string | Username of non-root user to run ceph-ansible | ceph_ansible
| `network_provider` | string | Type of plugin to use, see role documentation | `nm`
| `network_allow_restart` | string | Allow restart, see role documentation | `yes`
| `network_connections` | list | List of connections to manage, see role documentation | defined in inventory

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
- The `ceph` group also contains a definition for `network_connections`
