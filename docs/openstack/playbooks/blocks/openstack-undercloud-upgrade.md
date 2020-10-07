# Ansible Playbook: openstack undercloud upgrade

This playbook will:

- Install the latest TripleO packages using `dnf`
- Run the `openstack undercloud upgrade` command
- Reboot the `director` host
- Update the to the latest overcloud images in `/home/stack/images`
- Upload the latest overcloud images to Glance
- Configure all baremetal nodes to use the latest images

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```yml
- name: openstack undercloud upgrade
  import_playbook: blocks/openstack-undercloud-upgrade.yml
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

There are no variables that are required to be set.

## Inventory requirements

There are no inventory requirements.
