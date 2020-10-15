# Ansible Role: FPGA Setup

This role prepares a server equipped with one or more Intel N3000 FPGA card(s).

General workflow:

* Package setup
  * Register with Satellite
  * Install packages, including OPAE tools/SDK
  * Configure `fpgad`
* Determine work to be done based on hashes/versions reported by OPAE tools
* Validate presence of Production-level firmware
* Load desired bitstream image

Does not yet include:

* Firmware upgrade

# Requirements
This role has the following collection requirements:

* `community.general.redhat_subscription`

## Role Defaults

These variables can and should be adjusted to best fit the environment being implemented.

### Dictionary `fpga_satellite_info`

| Key | Type | Description |
| --- | ---- | ----------- |
| `server`   | string | Resolvable base address for Satellite server
| `key`      | string | The activation key to use when registering with Satellite
| `org`      | string | The organization to use when registering with Satellite
| `epel_repo` | string | The name of the EPEL repository set up in Satellite

### Dictionary `fpga_packages`

| Key | Type | Description |
| --- | ---- | ----------- |
| `epel`       | list of strings | Packages to install from the EPEL repository
| `opae_tools` | list of strings | Packages to install to enable use of OPAE tools (non-EPEL)
| `opae_fw`    | list of strings | Packages to install to enable firmware upgrade (non-EPEL) **[not implemented - this key is a placeholder]**

### Dictionary `fpga_files`
| Key | Type | Description |
| --- | ---- | ----------- |
| `loc`       | string | HTTP, HTTPS, or FTP base URL where bitstream and firmware images are hosted. See `url` parameter for [get_url](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/get_url_module.html).
| `bitstream` | dictionary of strings | This key should have sub-keys `4g` and `5g` with values corresponding to bitstream image files available from `loc` (above).

### Dictionary `fpga_want_build`
| Key | Type | Description |
| --- | ---- | ----------- |
| `n3000_2` | string | Desired firmware version string for **N3000 v2** cards. Must match a key available under `fpga_known_builds.n3000_2` (see Role Variables section)
| `n3000_n` | string | Desired firmware version string for **N3000-N** cards. Must match a key available under `fpga_known_builds.n3000_n` (see Role Variables section)

### Non-dictionary role defaults
| Variable | Type | Description |
| -------- | ---- | ----------- |
| `fpga_want_bitstream` | string | Desired bitstream image. Must be `4g` or `5g`.
| `fpga_reboot_timeout` | string | Timeout value (in seconds) to use when the role reboots the target server(s).

## Role Variables

These variables should generally not be adjusted, but you have the option to do so if necessary.

### Dictionary `fpga_known_builds`
| Key | Type | Description |
| --- | ---- | ----------- |
| `n3000_2` | dictionary of strings | Known firmware build strings for **N3000 v2** cards. Each sub-key should represent a firmware "version" to be referenced by `fpga_want_build.n3000_2` (see Role Defaults section). The value should match the build string expected to be reported for that version by the OPAE tools.
| `n3000_n` | dictionary of strings | Known firmware build strings for **N3000-N** cards. Each sub-key should represent a firmware "version" to be referenced by `fpga_want_build.n3000_n` (see Role Defaults section). The value should match the build string expected to be reported for that version by the OPAE tools.

### Dictionary `fpga_known_hashes`
| Key | Type | Description |
| --- | ---- | ----------- |
| `n3000_2` | string | Known BMC root entry hash reported by the OPAE tools for **N3000 v2** cards.
| `n3000_n` | string | Known BMC root entry hash reported by the OPAE tools for **N3000-N** cards.

### Dictionary `fpga_known_bitstreams`
| Key | Type | Description |
| --- | ---- | ----------- |
| `4g` | string | Known bitstream ID reported by the OPAE tools for FPGA cards which are loaded with the bitstream image defined in `fpga_files.bitstream.4g` (see Role Defaults section).
| `5g` | string | Known bitstream ID reported by the OPAE tools for FPGA cards which are loaded with the bitstream image defined in `fpga_files.bitstream.5g` (see Role Defaults section).

### Non-dictionary role variables
| Variable | Type | Description |
| -------- | ---- | ----------- |
| `fpga_temp_c_max` | float | Maximum temperature (in degrees Celsius) to tolerate when starting a firmware upgrade


## Inventory Requirements

This role does not use variables from common inventory sources.

This role is expected to run against dynamic OpenStack TripleO inventory in order to run against OpenStack compute nodes via Director proxy. Information on setup of this dynamic inventory is outside the scope of this document.

## Authentication

Authentication is expected to be handled via SSH key trust via the OpenStack Director (see *Inventory Requirements* above).
