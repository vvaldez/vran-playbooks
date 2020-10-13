# Ansible Playbook: Create RHV VMs

This playbook will:

- Create vms defined in `ovirt.vms`

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/rhv/create/vms.yml
```

## Requirements

This playbook has the following collection requirements:

  - `ovirt.ovirt`

This playbook has the following requirements:

  - `installation.yml` has been run

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `rhvm_api_host` | string | Which host to run API commands on | First member of group `rhvm` e.g. `groups['rhvm'].0` |

## Inventory requirements

- Group: `rhv`
- The above group contains the following dictionaries:
  - `ovirt`
