# Ansible Playbook: TOR Networking Config

This playbook calls the role `tor_networking_config`. The role readme should be referenced for further information.

The target is a group `tor_networking` which should contain switch devices.

Regarding the following lines:
```
  serial: 2
  order: sorted
```
These lines are present for a simulated scenario where two physical switches are being used to logically simulate many switches. This can be omitted when that is not the case.

An override for `ansible_command_timeout` is used. This is done because the `tor_networking_config` role can send many lines to a device at once, and it may need more time than the default to process. Adjust as needed.
