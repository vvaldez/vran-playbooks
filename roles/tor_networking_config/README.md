# Ansible Role: Networking

This role configures top-of-rack (TOR) switches for vRAN.

The `main.yml` task file reads a task file named according to the expected value of `ansible_network_os`. Currently, the supported values are:
* dellos10

It works via 3 major steps:

* *Build VLAN interfaces.* Read a site's network definition and build VLAN interfaces accordingly. 

* *Build Port Channels.* Read the switch's hostvars and build port channel interfaces accordingly.

* *Build single interfaces* Read the switch's hostvars and build single interfaces accordingly.

## Role Variables

Defaults are found at `defaults/main.yml` and they consist of the following:

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `tor_mtu`                   | integer | The MTU volue to set on port channels and single interfaces. MTU value for VLAN interfaces is not affected by this.
| `tor_lacp_fallback_timeout` | integer | The LACP fallback timeout value to include in port channel definitions.
| `tor_skip_vlans`            | list    | A list of VLANs, by name, *not* to build. Used to skip multiple SR-IOV and fronthaul networks beyond the first, as they are identical from a TOR switching perspective.
