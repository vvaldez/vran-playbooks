# Ansible Playbook: Deploy Ceph

This playbook will:

- Run `ceph-ansible` on ceph admin node

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/<datacenter>/inventory/ \
  playbooks/ceph/create/deploy_ceph.yml
```

## Requirements

This playbook has the following prerequisites:

- `configure_ceph.yml` must have been run successfully

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_automation_username` | string | Username of non-root user to run ceph-ansible | `ceph_ansible` |
| `ceph_admin_node` | string | Server to use to run ceph-ansible from | First member of ceph group e.g. `groups['ceph'].0` |
| `ceph_playbook_dir` | string | Location of ceph-ansible | `/usr/share/ceph-ansible` |
| `ceph_playbook` | string | Playbook to run | `site-container.yml` |
| `ceph_inventory` | string | Location of inventory | `/etc/ansible/hosts` |

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
