# Ansible Playbook: Destroy iSCSI Target

This playbook will:

- Copy iSCSI Target Destroy playbook from template that does the following:
- Remove disk images from first iSCSI Target
- Remove ceph nodes as gateways from first iSCSI Target
- Delete iSCSI Targets
- Delete rbd disk images

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/ceph/destroy/iscsi_target.yml
```

## Requirements

This playbook expects Ceph to be installed.

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_automation_username` | string | Username of non-root user to run ceph-ansible | ceph_ansible |
| `ceph_admin_node` | string | Server to use to run ceph-ansible from | First member of ceph group e.g. `groups['ceph'].0` |

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
- The `ceph` group also contains a definition for `iscsi_targets`
