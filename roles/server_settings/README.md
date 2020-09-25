# Ansible Role: Server Settings

This role updates system (BIOS/management) settings on baremetal servers.

It works on servers from the following vendors:

* Dell

# Requirements
This role's requirements depend on the server vendor.

Collection requirements for Dell:

* `dellemc.openmanage`

## Role Variables

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `ss_has_os` | boolean | Whether or not the targets have an OS on them. Will trigger a `wait_for_connection` at the end of execution if `true`.

## Inventory Requirements

This role makes use of the vRAN common `oob` dictionary. It uses the following parts (examples included):

```
oob:
  resource_ids:
    system: System.Embedded.1
    manager: iDRAC.Embedded.1
  SystemManufacturer: Dell
  config:
    bios:
      LogicalProc: "Enabled"
      [...]
    idrac:
      ServerPwr.1.PSRedPolicy: "A/B Grid Redundant"
      SetBootOrderEn: "HardDisk.List.1-1,NIC.Integrated.1-1-1"
      [...]
    pxe_allow: NIC.Integrated.1-1-1
```

## Authentication

Set the variables `oob_username` and `oob_password`. This can be done via custom Ansible Tower credential, or with Ansible Vault in inventory.
