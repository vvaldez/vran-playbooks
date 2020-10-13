# Ansible Playbook: Get iSCSI WWID

This playbook will:

- Ensure required packages are installed
- Determine existing block devices
- Attempt to discover iSCSI targets on given portal
- Update iSCSI discovery authentication for given portal
- Discover iSCSI targets on given portal
- Login to iSCSI target
- Determine any added block devices
- Ensure 1 new iSCSI LUN with size is found
  Logout of iscsi target
- Gather WWID
- Logout of iscsi target

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/rhv/read/get_iscsi_wwid.yml
```

## Requirements

This playbook has the following prerequisites:

- Host `groups['iscsi_client'].0` can reach the storage network.

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_admin_node` | string | Server to use to run ceph-ansible from | First member of ceph group e.g. `groups['ceph'].0` |
| `iscsi_discovery_username` | string | Ceph discovery username | |
| `iscsi_discovery_password` | string | Ceph discovery password | |
| `iscsi_chap_username` | string | Ceph CHAP username | |
| `iscsi_chap_password` | string | Ceph CHAP password | |
| `iscsi_portal` | string | Portal to query |  `hostvars[hostvars[ceph_admin_node].ceph.iscsi_targets.gateways.0.name].storage_ip` |
| `iscsi_target`  | string | Target name to use | `hostvars[ceph_admin_node].ceph.iscsi_targets.targets.0.name` |
| `iscsi_size` | string | Size of iSCSI LUN to use for Engine for hosted-engine setup | `hostvars[ceph_admin_node].ceph.iscsi_targets.images.0.size` |

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
- The `ceph` group also contains a definition for `iscsi_targets`
