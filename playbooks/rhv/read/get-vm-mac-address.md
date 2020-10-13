# Ansible Playbook: Get VM MAC Address

This playbook will:

- Query RHVM API for given VM MAC Address

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/rhv/read/get-vm-mac-address.yml
```

## Requirements

This playbook has the following collection prerequisites:

- `ovirt.ovirt`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `vm` | string | VM to get NIC info about | `demo` |
| `nic` | string | NIC to get info about for VM | `eth0` |
| `rhvm_api_host` | string | Which host to run API commands on | First member of group `rhvm` e.g. `groups['rhvm'].0` |

## Inventory requirements

- Group: `rhv`
- The above group contains the following dictionaries:
  - `ovirt`
