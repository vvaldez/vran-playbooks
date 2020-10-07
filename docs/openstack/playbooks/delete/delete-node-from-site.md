# Ansible Playbook: Add node to site

This role will:

- Add the `director` host to the `site_{{ site_name }}` group
- Upload ansible-generated templates
- Disable the overcloud compute service for `{{ server_name }}`
- Discover the UUID of the overcloud server `{{ server_name }}`
- Update the overcloud plan for `site_name`
- Delete the overcloud node `server_name`
- Delete the overcloud network agents for `server_name`
- Run Tempest smoke tests

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
  -e site_name=edge1
  -e server_name=edge1-compute-virtual-0
  playbooks/openstack/delete/delete-node-from-site.yml
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `site_name` | string | The name of the site to deploy. There must be a corresponding group called `site_{{ site_name }}`
| `server_name` | string | The name of the server to delete. This needs to be the name of the server as shown from the output of `openstack server list` when sourcing the overcloudrc file.

## Inventory requirements

- There is a `site_{{ site_name }}` group
- The above group contains the following dictionaries:
  - `site.{{ site_name }}`
- There is an `openstack` group
- The above group contains the following dictionaries:
  - `undercloud`
  - `overcloud`
  - `instackenv`
