# Ansible Playbook: Server Firmware (Generic)

This playbook calls the role `server_firmware_generic`. The role readme should be referenced for further information.

This does not make use of any vendor-specific tools, where `server_firmware` does.

# Plays

## Play 1

Include the role against server groups known to be non-clustered. These hosts will be configured in parallel (all at once, according to the Ansible environment's fork settings).

## Play 2

Include the role against server groups known to be clustered. These hosts will be configured in serial (one at a time).
