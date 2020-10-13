# Ansible Playbook: Install Ceph

NOTE: This playbook is automatically called as part of the `installation.yml` playbook.

This playbook will:

- Read existing nic bond configuration specified in variable
- Generate config for bond that `hosted-engine setup` expects so it does not attempt to configure it

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/rhv/create/fix_hosted_engine_network.yml
```

## Requirements

This playbook has the following requirements:

  - specified bond is already configured

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `nic_bond` | string | Which NIC configuration used for storage connection to configure | bond2 |

## Inventory requirements

None.
