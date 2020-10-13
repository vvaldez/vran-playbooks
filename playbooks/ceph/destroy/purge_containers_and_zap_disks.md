# Ansible Playbook: Purge Containers and Zap Disks

This playbook will:

- Remove all podman containers
- Remove all podmain container images
- Remove all Ceph device lvm volume groups
- Remove all Ceph lvm physical volume labels
- Zap all Ceph disks

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/<datacenter>/inventory/ \
  playbooks/ceph/destroy/purge_containers_and_zap_disks.yml
```

## Requirements

This playbook expects Ceph to be installed.

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `osd_device_size` | string | Device size as reported in `/proc/partitions for OSD disks` | `1758164184` |
| `db_device_size` | string | Device size as reported in `/proc/partitions for DB disks` | `468851544` |

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
- The `ceph` group also contains a definition for `network_connections`
