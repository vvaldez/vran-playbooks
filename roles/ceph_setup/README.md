# Ansible Role: Ceph Setup

This role will setup a specific non-root user and generate and distribute SSH keys for the intention of running `ceph-ansible`.

This role will:

- Create specified `ceph_automation_username`
- Set password specified for `ceph_automation_username`
- Grant `ceph_automation_username` sudo access
- Create SSH keypair for `ceph_automation_username`
- Copy `ceph_automation_username` SSH public key to host

## Requirements

This role has no specific requirements.

## Role variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_automation_username` | string | Username of non-root user to run ceph-ansible | `ansible` |
| `ceph_automation_password` | string | Password for `ceph_automation_username` | |

## Authentication

The variables `ceph_automation_username` and `ceph_automation_password` should be set via custom Ansible Tower credential or with Ansible Vault in inventory.
