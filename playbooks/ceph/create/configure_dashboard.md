# Ansible Playbook: Configure Dashboard

This playbook will:

- Set dashboard to listen on given host
- Restart Ceph Manager services

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/<datacenter>/inventory/ \
  playbooks/ceph/create/configure_dashboard.yml
```

## Requirements

This playbook has the following prerequisites:

- `deploy_ceph.yml` must have been run successfully

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `ceph_automation_username` | Username of non-root user to run ceph-ansible | ceph_ansible |
| `ceph_admin_node` | string | Server to use to run ceph-ansible from | First member of ceph group e.g. `groups['ceph'].0` |
| `ceph_dashboard_host` | string | Host to configure for dashboard |  `ceph_cluster.0` |
| `podman_command` | string | Command for podman | `podman exec -t ceph-mgr-{{ inventory_hostname_short }} bash -c`

## Inventory requirements

- Group: `ceph`
- The above group contains the following dictionaries:
  - `ceph`

