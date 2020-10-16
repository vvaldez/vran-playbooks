# Ansible Role: Discover Mac

This role will:

- Loop thru each item in `{{ instackenv }}`
  - If `item.pm_type == 'staging_ovirt'`
    - Find the `ansible_host` value of `item.name` and use the URI module to contact it's Redfish API. The credentials should come from `{{ oob_username }}` and `{{ oob_password }}`
    - Query the RedFish API for the first network adapter and return it's MAC address
  - If `item.pm_type == 'pxe_drac'`
    - Connect to the the oVirt API defined at `{{ rhv.he_fqdn }}`. The credentials that will be used are `{{ rhv_admin_username }}@internal` and `{{ rhv_admin_password }}`
    - Query the oVirt API for the `eth0` MAC address of the VM named `item.name`
- Append the following fields to the `instackenv` item:
    - `mac`
    - `pm_addr`
    - `pm_user`
    - `pm_password`

Simply, this role takes `{{ instackenv }}` and appends the above fields to each item in the list, if the item matches known `pm_addr` types.

Here is an example of a valid `{{ instackenv }}` list:

```yml
instackenv:
  - name: controller-central-1
    pm_type: staging-ovirt
    pm_vm_name: controller-central-1
    capabilities: 'profile:controller-central,boot_option:local'

  - name: compute-sriov-central-1
    pm_type: pxe_drac
    capabilities: 'profile:compute-sriov-central,boot_option:local'

  ...
```

## Usage

The following is an example usage of the role:

```yml
- import_role:
    name: discover
```

## Requirements

The following requirements need to be met.

- Connectivity to both the Redfish and oVirt APIs from the `director` host
- Specifically for `pxe_drac` nodes, the host must exist as an Ansible host and have it's `ansible_host` value set correctly. e.g. from the Ansible hosts file:

  ```yml
  compute-sriov-central-1:
    hostname: compute-sriov-central-1.escwq.com
    ansible_host: 172.17.120.33
  ```

## Role variables

The are no role variables required to be set.

## Inventory requirements

The following variables are required to be set somewhere inventory or in Tower credentials.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `instackenv` | list | The instackenv list to loop over
| `oob_username` | string | The username to use for `pxe_drac` items. Not needed if there are no such items.
| `oob_password` | string | The password to use for `pxe_drac` items. Not needed if there are no such items.
| `rhv.he_fqdn` | string | The oVirt API to contact for `staging_ovirt` items. Not needed if there are no such items.
| `rhv_admin_username` | string | The oVirt API username for `staging_ovirt` items. The username used will be `{{ rhv_admin_username }}@internal`. Not needed if there are no such items.
| `rhv_admin_password` | string | The oVirt API username for `staging_ovirt` items. Not needed if there are no such items.
