# Ansible Playbook: Configure Ceph

This playbook will:

- Configure ceph inventory on ceph admin node
- Create automation user to run ceph-ansible
- Create and distribute SSH keys to establish keyless exchange from ceph ansible node
- Copy inventory group variables onto ceph ansible node
- Create Ansible inventory on ceph ansible node with ceph cluster members

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/ceph/create/configure_ceph.yml
```

## Requirements

This playbook has the following prerequisites:

- `install_ceph.yml` must have been run successfully

This playbook has the following role requirements:

- `ceph_setup`
- `ceph_ansible_inventory`


## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_admin_node` | string | Server to use to run ceph-ansible from | First member of ceph group e.g. `groups['ceph'].0` |
| `ceph_cluster` | list | List of cluster hosts used to generate inventory | `groups['ceph']` |
| `ceph_automation_username` | string | Username of non-root user to run ceph-ansible | `ceph_ansible` |

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
