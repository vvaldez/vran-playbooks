# Ansible Playbook: Purge Cluster

This playbook will:

- Copy purge cluster playbook from infrastructure folder into ceph-ansible folder

**Note**: Currently this playbook doest NOT run the purge playbook as it requires interactive confirmation but will prepare it to be run.

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/<datacenter>/inventory/ \
  playbooks/ceph/destroy/purge_cluster.yml
```

## Requirements

This playbook expects Ceph to be installed.

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_admin_node` | string | Server to use to run ceph-ansible from | First member of ceph group e.g. `groups['ceph'].0` |
| `ceph_cluster` | list | List of cluster hosts used to generate inventory | `groups['ceph']` |
| `ceph_automation_username` | string | Username of non-root user to run ceph-ansible | `ceph_ansible` |
| `ceph_playbook_dir` | string | Location of ceph-ansible | `/usr/share/ceph-ansible` |
| `ceph_playbook` | string | Purge playbook to prepare | `purge-container-cluster.yml` |
| `ceph_inventory` | string | Ceph inventory file | `/etc/ansible/hosts` |


## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`
- The `ceph` group also contains a definition for `network_connections`
