# Ansible Playbook: openstack overcloud node delete

This playbook will:

- The `stackrc` file will be sourced and all node UUIDs listed in `{{ tripleo_overcloud_node_delete_nodes }}` will be deleted from the `{{ tripleo_overcloud_node_delete_stack }}` stack
- If successful, show the output of `openstack stack list`
- If unsuccessful, show the output `openstack stack failures list`

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```yml
- name: "openstack overcloud node delete {{ site_name }}"
  import_playbook: ../blocks/openstack-overcloud-node-delete.yml
  vars:
    tripleo_overcloud_node_delete_stack: "{{ site_name }}"
    tripleo_overcloud_node_delete_nodes: "{{ node_uuid }}"
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `tripleo_overcloud_node_delete_stack` | string | The name of the overcloud stack to delete nodes from
| `tripleo_overcloud_node_delete_nodes` | list | A list of strings. Each string is the UUID of the node to delete. UUIDs should be as shown from running `openstack server list` when sourcing `stackrc`

## Inventory requirements

No inventory requirements.
