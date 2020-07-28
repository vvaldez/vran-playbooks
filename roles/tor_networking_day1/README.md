# Ansible Role: Networking

This role configures top-of-rack (TOR) switches running Dell EMC Networking OS10.

It works via two major steps:

* *Build VLAN interfaces.* Read a dictionary `networks` (expected to be available via Group Variables). VLAN interfaces are built on the switch using this information. 

* *Build Port Channels.* Port channels and their member interfaces are built on the switch using a dictionary `host_networking` found in the Host Variables of hosts belonging to the groups listed in the role variable `networking_read_groups`.

## Role Variables

Defaults are found at `defaults/main.yml` and they consist of the following:

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `networking_skip_vlans`       | list | When reading the `networks` dictionary to build VLANs, skip any dictionary key defined here.
| `networking_read_groups`      | list | When reading `hostvars` to build Port Channels, include hosts found within groups defined here.
| `networking_port_channel_mtu` | integer | The MTU value to set on all Port Channels.

## Non-role Variables

### For VLAN creation

This role expects to find a dictionary called `networks` defined in the Group Variables of a group that the TOR switches belong to. For example, if the TOR switches are in a group called "networking" then `networks` could be defined in `group_vars/networking.yml` or `group_vars/all.yml` according to the needs of other roles.

Each key in `networks` should have another dictionary as its value. Within these value dictionaries, the role looks for the following keys:

| Key | Type | Description |
| --- | ---- | ----------- |
| `vlan_tag` | integer | The ID number of the VLAN interface to build. For example, to build `interface vlan5`, this value should be `5`
| `mtu`      | integer | The MTU value. Example: `9216`

If `vlan_tag` is missing, or if the network's key exists within the role variable `networking_skip_vlans`, the network/VLAN will be skipped. If `vlan_tag` is present, but `name` and/or `mtu` are missing, the VLAN will still be created without the missing value(s).

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

This role expects to find a list called `host_networking` defined for each host present in the groups specified in `networking_read_groups`. Each list item should have the following keys:

TODO: describe the dicitonary

#### Example: `host_vars/compute1.yml`

TODO: example
