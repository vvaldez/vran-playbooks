# Ansible Playbook: Add Central Site

This role will:

- Upload ansible-generated templates
- Import **all** overcloud nodes
- Map neutron ports for **all** overcloud nodes
- Introspect all baremetal nodes in a `manageable` state
- Create roles for all overcloud nodes, if they don't already exist
- Deploy the `central` site
- Create an aggregate called `central` in the `central` availabilty zone
- Run tempest smoke tests

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
  playbooks/openstack/add/add-central-site.yml
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

There are no variables that are required to be set.

## Inventory requirements

- There is a `site_central` group
- The above group contains the following dictionaries:
  - `site.central`
- There is an `openstack` group
- The above group contains the following dictionaries:
  - `undercloud`
  - `overcloud`
  - `instackenv`
