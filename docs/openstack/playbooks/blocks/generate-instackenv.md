# Ansible Playbook: Generate instackenv

This playbook will:

- Generate the `instackenv` dictionary by retrieving the MAC addresses of nodes of `pm_type`:
  - `pxe_drac`
  - `staging_ovirt`

The playbook does not actually write the file. It takes the existing `instackenv` dictionary and modifies it's list items (if the item has one of the `pm_types` listed above) to add several fields to each list item:

- `mac`
- `pm_address`
- `pm_user`
- `pm_password`

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```yml
- import_playbook: blocks/generate-instackenv.yml
```

## Requirements

This playbook has the following role requirements:

- `discover`

## Playbook variables

There are no variables that are required to be set.

## Inventory requirements

- There is an `openstack` group
- The above group contains the following variables:
  - `instackenv`
- If the node is of `pm_type: pxe_drac`, then there exists the following variables with credential information:
  - `hostvars[node.name].ansible_host` (This finds the address of the host)
  - `oob_username`
  - `oob_password`
- If the node is of `pm_type: staging_ovirt`, then there exists the following variables with credential information:
  - `rhv.he_fqdn`
  - `rhv_admin_username`
  - `rhv_admin_password`
