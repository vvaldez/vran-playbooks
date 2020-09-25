# Ansible Role: TOR Networking

This role configures top-of-rack (TOR) switches for vRAN.

The `main.yml` task file reads a task file named according to the expected value of `ansible_network_os`. Currently, the supported values are:
* dellos10

It works via 3 major steps:

* *Build VLAN interfaces.* Read a site's network definition and build VLAN interfaces accordingly.

* *Build Port Channels.* Read the switch's hostvars and build port channel interfaces accordingly.

* *Build single interfaces.* Read the switch's hostvars and build single interfaces accordingly.

## Role Variables

Defaults are found at `defaults/main.yml` and they consist of the following:

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `tor_mtu`                   | integer | The MTU volue to set on port channels and single interfaces (but not VLAN interfaces).
| `tor_lacp_fallback_timeout` | integer | The LACP fallback timeout value to include in port channel definitions.
| `tor_remove_config`         | boolean | Toggles on/off behavior that removes port-channel interfaces and defaults ethernet interfaces before applying the defined config.

 Port channels, and physical interfaces not belonging to a port channel, will have the value of `tor_mtu` set as their MTU value. VLAN interfaces will use an MTU value if specified in the source data, but otherwise will not have am MTU specified. Member interfaces of a port channel will not ever have a MTU value set explicitly.

## Inventory Requirements

This role expects you to set a variable `site_name` containing the name of the site that any given TOR switch is serving: `central`, `edge1`, etc. Set this for each TOR switch host. The role will use the network information found in the `site` dictionary according to the first host found in the group `site_x`, where `x` is the value of `site_name`. This is where VLAN information is sourced from.

This role expects you to create a dictionary `network_roles` containing all potential roles a connected endpoint may have. Each of these roles should contain a dictionary of interface names. Each of these interface names should define which `access_network` (string) and/or `trunk_networks` (list of strings) are required on that interface. The string values are looked up and converted to VLAN IDs by the role.

For example:
```
network_roles:
  role_a:
    bond0:
      access_network: ssh_mgmt
      trunk_networks:
        - ssh_mgmt
        - storage
    ens3f0:
      access_network: ssh_mgmt
  role_b:
    bond0:
      access_network: provisioning
      trunk_networks:
        - provisioning
        - storage
        - internal_api
        - tenant
        - external
```

Interfaces with only `access_network` defined will result in an access mode port on the switch. Interfaces with both `access_network` and `trunk_networks` defined will result in a trunk mode port on the switch, with a native VLAN of `access_network`. Interfaces with only `trunk_networks` defined will result in a trunk mode port on the switch with no configuration specifying a native VLAN.

This `network_roles` dictionary should be defined for each type of site. Intended use is to make a group `site_central_tor` for the central site, and one group `site_edge_tor` to function for all edge sites. The `network_roles` dictionary can be defined in the group_vars for each.

A third group with a name such as `tor_networking` should be established to contain these two groups. A playbook calling the role would target this group. This group's group_vars are an appropriate place to set any overrides of the role defaults, as well as the value of `ansible_network_os`.

Example group setup in YAML inventory:
```
site_central_tor:
  hosts:
    tor-central-leaf-1.example.com:
      site_name: central
    tor-central-leaf-2.example.com:
      site_name: central
site_edge_tor:
  hosts:
    tor-edge1-leaf-1.example.com:
      site_name: edge1
    tor-edge1-leaf-2.example.com:
      site_name: edge1
    tor-edge2-leaf-1.example.com:
      site_name: edge2
    tor-edge2-leaf-2.example.com:
      site_name: edge2
tor_networking:
  children:
    site_central_tor:
    site_edge_tor:
```

The role also expects to find `tor_interfaces` in each TOR switch host's host_vars. This is a list, with each item containing the following keys:

* `network_role`: The role of the connected endpoint, as found in `network_roles`.
* `host_interface`: The name of the connected endpoint's interface, as found in `network_roles`.
* `host_name`: The name of the connected endpoint. Only used for description, not used for lookup.
* `interface_name`: The name of the switch interface connected to the endpoint on `host_interface`.
* `port_channel_id`: The ID number of the port channel, if defining a bonded interface. Leave as a blank string if not applicable.

For example:
```
tor_interfaces:
-   host_interface: bond0
    host_name: compute-1.example.com
    interface_name: ethernet1/1/4:4
    network_role: role_a
    port_channel_id: '16'
-   host_interface: ens3f0
    host_name: compute-1.example.com
    interface_name: ethernet1/1/4:3
    network_role: role_a
    port_channel_id: ''
```
