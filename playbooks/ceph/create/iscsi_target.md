# Ansible Playbook: Configure iSCSI Targets

This playbook will:

- Copy iSCSI Target Create playbook from template that does the following:
- Create rbd disk images
- Create iSCSI Targets
- Add ceph nodes as gateways to first iSCSI Target
- Add disk images to first iSCSI Target
- Disable host-based authentication
- Set CHAP authentication on first iSCSI Target
- Set discovery authentication on first iSCSI Target

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/<datacenter>/inventory/ \
  playbooks/ceph/create/iscsi_target.yml
```

## Requirements

This playbook has the following prerequisites:

- `deploy_ceph.yml` must have been run successfully

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_automation_username` | string | Username of non-root user to run ceph-ansible | `ceph_ansible` |
| `ceph_admin_node` | string | Server to use to run ceph-ansible from | First member of ceph group e.g. `groups['ceph'].0` |
  `ceph_discovery_username` | string | Ceph discovery username | |
| `ceph_discovery_password` | string | Ceph discovery password | |
| `ceph_chap_username` | string | Ceph CHAP username | |
| `ceph_chap_password` | string | Ceph CHAP password | |

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
- The `ceph` group also contains a definition for `iscsi_targets`
