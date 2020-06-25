# Ansible Role: Red Hat Subscription Manager Reigster

This role will register a system to Red Hat upstream CDN or a Satellite server. For access to manually created yum repositories, see `software_repos` role.

## Requirements

Access to Red Hat Subscription Manager upstream or Satellite server including authenticaiton information.

## Role Variables

Available variables are listed below (see `defaults/main.yml`):

Username:

    rhsm_username: 'rhsm_username'

Password:

    rhsm_password: 'rhsm_password'

Clean previous registration:

    rhsm_clean_subscription: False

Perform system update after registration:

    rhsm_update_system: False

If defined, will attach to these pool IDs (optional)

    rhsm_pool_ids: 
      - 12345

If defined, will set RHEL release to this version:

    rhsm_rhel_release: '7.7'

Which repositories to enable:

    rhsm_repos:
      - rhel-7-server-rpms

List of packages to install:

    rhsm_packages:
      - yum-utils

The following variables are available when registering with Satellite:

    rhsm_register_with_satellite: False
    rhsm_satellite_server: ''
    rhsm_satellite_activationkey: ''
    rhsm_satellite_organization: ''
    rhsm_satellite_clean: False

## Dependencies

None.

## Example Playbook

    - hosts: all
      become: True
      tasks:
      - import_role:
          name: rhsm_register

## License

GPLv3

## Author Information

This role was created in 2020 by the Red Hat consulting team (Vinny Valdez, Sohaib Azed, Ihor Stehantsev)