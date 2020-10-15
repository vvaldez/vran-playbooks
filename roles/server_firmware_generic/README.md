# Ansible Role: Server Firmware (Generic)

This role updates firmware on baremetal servers using only Redfish wherever possible.

It has been tested on servers from the following vendors:

* Dell

Out-of-band manager (iDRAC and similar) update logic does not exist for vendors not in this list.

# Requirements

## Collections

Collection requirements are as follows:

* `community.general`

## Notes by platform

### Dell ###

* No Dell-specific modules are required for Dell servers. Anything specific to Dell is accomplished via `racadm`.
* Be aware that older versions of `racadm` enforce a 64 character limit on filenames. Filenames within the `fw_manager` dictionary should be kept under this limit.


## Infrastructure

This role expects to use HTTP sources. Firmware images to be used should be hosted and available via HTTP. See *Role Defaults*.

# Role Defaults

## Non-dictionary

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `fw_has_os` | boolean | Whether or not to wait at the end of role execution for OS connectivity. Has no impact on reboot method.

## Dictionary: `fw_file_info`

| Key | Type | Description |
| --- | ---- | ----------- |
| `manager_base_uri`  | string | HTTP base URI where manager (iDRAC, etc) image files are hosted.
| `firmware_base_uri` | string | HTTP base URI where non-manager firmware image files are hosted.
| `bundle_ver`        | string | Path between base URI and file name, for use with bundling related images together.

## Dictionary: `fw_manager`
| Key | Type | Description |
| --- | ---- | ----------- |
| `search`  | string | The string to search for within the reported Redfish inventory that identifies the manager component.
| `updates` | list of dictionaries | Each dictionary should have a key `filename` with the base name of a manager image file, and `version` that describes the image version found within the file.

The role will apply updates found in `updates` in the order they are found in the list, as long as the reported manager version is below the value found in `version`. This is to address very old versions that need intermediate steps to get to later versions.

## List of dictionaries: `fw_file_info`

Each dictionary in the list should adhere to the following:

| Key | Type | Description |
| --- | ---- | ----------- |
| `search`   | string | The string to search for within the reported Redfish inventory that identifies a specific firmware component.
| `filename` | string | Base name of the firmware image file to apply to components matching `search`.
| `version`  | string | Version string that describes the image version found within `filename`.

## Inventory Requirements

This role makes use of the vRAN common `oob` dictionary. It uses the following parts (examples included):

```
oob:
  resource_ids:
    system: System.Embedded.1
    manager: iDRAC.Embedded.1
  SystemManufacturer: Dell
  ipaddr: 192.168.1.10
```

## Authentication

Set the variables `oob_username` and `oob_password`. This can be done via custom Ansible Tower credential, or with Ansible Vault in inventory.
