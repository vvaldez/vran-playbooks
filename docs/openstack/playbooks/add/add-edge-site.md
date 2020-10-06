# Ansible Playbook: Add edge site

This role will:

- Add the `director` host to the `site_{{ site_name }}` group
- Upload ansible-generated templates
- Run `openstack undercloud install`
- Update the `central` stack by running `openstack overcloud deploy central`
- Import **all** overcloud nodes
- Map Neutron ports for **all** overcloud nodes
- Introspect all baremetal nodes in a `manageable` state
- Create roles for all overcloud nodes, if they don't already exist
- Deploy the `{{ site_name }}` stack
- Create an aggregate called `central` in the `central` availabilty zone, if it doesn't already exist
- Run Tempest smoke tests

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
  -e site_name=edge1
  playbooks/openstack/add/add-edge-site.yml
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `site_name` | string | The name of the site to deploy. There must be a corresponding group called `site_{{ site_name }}`

## Inventory requirements

- There is a `site_{{ site_name }}` group
- The above group contains the following dictionaries:
  - `site.{{ site_name }}`
- There is an `openstack` group
- The above group contains the following dictionaries:
  - `undercloud`
  - `overcloud`
  - `instackenv`
