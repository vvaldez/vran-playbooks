# Ansible Playbook: Install RHV

This playbook will:

- Extend root system volume to use all 100% of space
- Set system hostname
- Inject host entry into /etc/hosts
- Register to Satellite
- Set dnf module streams (this currently reports changed every run)
- Install RHV packages
- Configure Cockpit
- Configure firewall
- Setup OS networking
- Run `fix_hosted_engine_network.yml` playbook so network isn't broken during hosted-engine setup
- Using `iscsi_target` host, login to iSCSI Target to retrieve `WWID` for use in RHV hosted-engine setup
- Run `hosted-engine setup` on the first RHV host

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  --inventory ../ansible-inventory/<datacenter>/inventory/ \
  --extra-vars @secrets.yml \
  playbooks/rhv/create/installation.yml
```

## Requirements

This playbook has the following role requirements:

  - `oasis_roles.system.hostname`
  - `oasis_roles.system.firewalld`
  - `linux-system-roles.network`
  - `oasis_roles.system.rhsm`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `hostname_inject_hosts_files` | string | Inject hostname vial oasis role into /etc/hosts | `false` |
| `ceph_admin_node` | string | Which node to use for host variables lookup | `groups['ceph'].0` |
| `iscsi_size` | string | Size of iSCSI LUN to use for Engine for hosted-engine setup | `hostvars[ceph_admin_node].ceph.iscsi_targets.images.0.size` |
| `rhvm_initial_host` | string | Which RHV host to use for hosted-engine setup | The first member of the RHV group e.g. `groups['rhvh'].0 ` |

## Inventory requirements

- Group: `rhv`
- The above group contains the following dictionaries:
  - `rhv`
- Group: `ceph`
- The above group contains the following dictionaries:
  - `iscsi_targets`
