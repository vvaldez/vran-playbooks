# Ansible Playbook: openstack overcloud node introspect

This playbook will:

- Introspect all Ironic nodes that are in `provision-state` `manageable`

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```yml
- name: openstack overcloud node introspect
  import_playbook: ../blocks/openstack-overcloud-node-introspect.yml
  tags:
    - openstack overcloud node introspect
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

There are no variables that are required to be set.

## Inventory requirements

There are no inventory requirements.
