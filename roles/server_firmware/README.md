# Ansible Role: Server Firmware

This role updates firmware on baremetal servers.

It works on servers from the following vendors:

* Dell

# Requirements
This role's requirements depend on the server vendor.

Collection requirements for Dell:

* `dellemc.openmanage`

## Role Variables

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `fw_mode`      | string | Must be either `online` or `offline`. The `online` option will use the manufacturer's online firmware repository.
| `fw_repo_name` | string | The name of the OFFLINE firmware repository to use with `fw_mode: offline`.
| `fw_repo_ver`  | string | The version string to use with OFFLINE firmware repository - expected to be a directory under `fw_repo_name`.

## Inventory Requirements

This role makes use of the vRAN common `oob` dictionary. It uses the following parts (examples included):

```
oob:
  resource_ids:
    system: System.Embedded.1
    manager: iDRAC.Embedded.1
  SystemManufacturer: Dell
```

To use an offline repo, you additionally need:

```
oob:
  firmware:
    nfs_uri: 10.0.0.10:/fileshare/firmware
```

## Authentication

Set the variables `oob_username` and `oob_password`. This can be done via custom Ansible Tower credential, or with Ansible Vault in inventory.
