# Ansible Playbook: Delete edge site

This role will:

- Delete the `{{ site_name }}` stack
- Run Tempest smoke tests

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
  -e site_name=edge1
  playbooks/openstack/add/delete-edge-site.yml
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `site_name` | string | The name of the site to delete.

## Inventory requirements

There are no inventory requirements.
