# Ansible Playbook: Tempest run

This playbook will:

- If `remove` is `true` then delete any existing Tempest workspace found at `/home/stack/tempest/{{ tempest_workspace }}`
- If there is not an existing Tempest workspace named `{{ tempest_workspace }}`, then:
  - Initialize the Tempest workspace named `{{ tempest_workspace }}`
  - Gr

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```yml
- name: openstack undercloud upgrade
  import_playbook: blocks/openstack-undercloud-upgrade.yml
```

## Requirements

No requirements

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `tempest_workspace` | string |

The following variables can be optionally set, and have default values, if not set.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `remove` | bool | `false` |
| `concurrency` | int | `0` |

## Inventory requirements

There are no inventory requirements.
