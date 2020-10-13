# Ansible Role: Ceph Ansible Inventory

This role is used to prepare the first node of a ceph cluster with inventory for a ceph-ansible run. The group used to define inventory for is passed as a variable `ceph_cluster`. The first member will be used to stage inventory (/etc/ansible/hosts) and group vars (/usr/share/ceph-ansible/group_vars/).

Currently only a couple of additional groups are created (e.g. all, osds and iscsigws) but can easily be modified. Simply add the appropriate template in the `templates/` directory and modify `tasks/main.yml` and add any additional groups to the main loop.

## Requirements

This role has no specific requirements.

## Role variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_cluster` | list | List of cluster hosts used to generate inventory | `groups['ceph']` |
