# Ansible Playbook: Deploy Tower

This playbook will:

- Register Tower VM to RHSM upstream
- Run the role `tower_setup` see the role (../roles/tower_setup/README.md)[README] for details
- Run the role `tower_config` see the role (../roles/tower_config/README.md)[README] for details

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/tower/create/deploy_tower.yml
```

## Requirements

This playbook has the following prerequisites:

- Tower VM must be created and accessible, this is possible via `playbooks/kvm/domain_tower.yml`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `tower_config_type` | string | What type of Tower config to apply (see role for details) | `Minimal` |

## Inventory requirements

None.
