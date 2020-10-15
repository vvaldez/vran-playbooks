# Ansible Playbook: Server Firmware

This playbook calls the role `server_firmware`. The role readme should be referenced for further information.

This makes use of Dell-specific tools, where `server_firmware_generic` does not.

# Plays

## Play 1

Include the role against server groups known to be non-clustered. These hosts will be configured in parallel (all at once, according to the Ansible environment's fork settings).

## Play 2

Include the role against server groups known to be clustered. These hosts will be configured in serial (one at a time).
