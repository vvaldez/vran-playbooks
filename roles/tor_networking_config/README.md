# Ansible Role: Networking

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

 Port channels, and physical interfaces not belonging to a port channel, will have the value of `tor_mtu` set as their MTU value. VLAN interfaces will use an MTU value if specifid in the source data, but otherwise will not have am MTU specified. Member interfaces of a port channel will not ever have a MTU value set explicitly.
