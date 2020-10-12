# Ansible Playbook: openstack undercloud install

This playbook will:

- Copy `/home/stack/ansible-generated/undercloud.conf` to `/home/stack/undercloud.conf`
- Run `openstack undercloud install`

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```yml
- name: openstack undercloud install
  import_playbook: blocks/openstack-undercloud-install.yml
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

There are no variables that are required to be set.

## Inventory requirements

There are no inventory requirements.
