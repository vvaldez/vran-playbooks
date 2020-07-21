# Ansible Role: Networking

This role configures top-of-rack (TOR) switches running Dell EMC Networking OS10.

It works via two major steps:

* *Build VLAN interfaces.* Read a dictionary `networks` (expected to be available via Group Variables). VLAN interfaces are built on the switch using this information. 

* *Build Port Channels.* Port channels and their member interfaces are built on the switch using a list `port_channels` found in the Host Variables of hosts belonging to the groups listed in the role variable `networking_read_groups`.

## Role Variables

Defaults are found at `defaults/main.yml` and they consist of the following:

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `networking_skip_vlans`  | list | When reading the `networks` dictionary to build VLANs, skip any dictionary key defined here.
| `networking_read_groups` | list | When reading `hostvars` to build Port Channels, include hosts found within groups defined here.

## Non-role Variables

### For VLAN creation

This role expects to find a dictionary called `networks` defined in the Group Variables of a group that the TOR switches belong to. For example, if the TOR switches are in a group called "networking" then `networks` could be defined in `group_vars/networking.yml` or `group_vars/all.yml` according to the needs of other roles.

Each key in `networks` should have another dictionary as its value. Within these value dictionaries, the role looks for the following keys:

| Key | Type | Description |
| --- | ---- | ----------- |
| `name`     | string  | The name of the VLAN, to be used as the `vlan-name`
| `vlan_tag` | integer | The ID number of the VLAN interface to build. For example, to build `interface vlan5`, this value should be `5`
| `mtu`      | integer | The MTU value. Example: `9216`

If `vlan_tag` is missing, or if `name` exists within the role variable `networking_skip_vlans`, the network/VLAN will be skipped. If `vlan_tag` is present, but `name` and/or `mtu` are missing, the VLAN will still be created without the missing value(s).

#### Example: `group_vars/all.yml`
```
[...]
networks:
  external_api:
    name: external_api
    vlan_tag: 119
    mtu: 9000
  provisioning:
    name: provisioning
    vlan_tag: 120
    mtu: 9000
[...]
```

### For Port Channel creation

This role expects to find a list called `port_channels` defined for each host present in the groups specified in `networking_read_groups`. Each list item should have the following keys:

| Key | Type | Description |
| --- | ---- | ----------- |
| `id`            | integer    | The ID number of the port channel to build. For example, to build `interface port-channel5`, this value should be `5`
| `allowed_vlans` | string     | The VLANs to permit on the trunk. This is a comma-seperated value, no spaces, ranges permitted. For example: `108,110-114`
| `mtu`           | integer    | The MTU value. Example: `9216`
| `interfaces`    | dictionary | A dictionary with `key: value` pairs equivalent to `switch_name: interface_name`, indicating which switch has which phyiscal interface participating in the port channel. For example: `{ 'leaf1': 'ethernet1/1/32', 'leaf2': 'ethernet1/1/32' }`

#### Example: `host_vars/compute1.yml`
```
[...]
port_channels:
  - id: 1001
    allowed_vlans: 108,110-114
    mtu: 9216
    interfaces:
      leaf1: ethernet1/1/32
      leaf2: ethernet1/1/32
[...]
```