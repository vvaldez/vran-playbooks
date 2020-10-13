# Ansible Playbook: Configuration RHV

This playbook will:

- Using `iscsi_target` host, login to iSCSI Target to retrieve `WWID` for use in RHV hosted-engine setup
- Add additional hosts in RHV group to datacenter
- Attach storage domains
- Create ovirt networks
- Create ovirt vnic profiles
- Attach ovirt networks to hosts

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/rhv/create/configuration.yml
```

## Requirements

This playbook has the following collection requirements:

  - `ovirt.ovirt`

This playbook has the following requirements:

  - `installation.yml` has been run

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_admin_node` | string | Which node to use for host variables lookup | `groups['ceph'].0` |
| `iscsi_size` | string | Size of iSCSI LUN to use for Engine for hosted-engine setup | `hostvars[ceph_admin_node].ceph.iscsi_targets.images.0.size` |
| `iscsi_wwid` | string | WWID of the Data storage domain | Dynamically gathered but can be specified e.g. `360014055972e88b045b4db08816a8e02` |
| `rhvm_api_host` | string | Which host to run API commands on | First member of group `rhvm` e.g. `groups['rhvm'].0` |

## Inventory requirements

- Group: `rhv`
- The above group contains the following dictionaries:
  - `rhv`
  - `ovirt`
- Group: `ceph`
- The above group contains the following dictionaries:
  - `iscsi_targets`
