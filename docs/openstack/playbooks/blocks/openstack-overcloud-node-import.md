# Ansible Playbook: openstack overcloud node import

This playbook will:

- Run the `openstack overcloud node import` command using `{{ tripleo_overcloud_node_import_environment_file }}`

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```yml
- name: openstack overcloud node import
  import_playbook: ../blocks/openstack-overcloud-node-import.yml
  vars:
    tripleo_overcloud_node_import_environment_file: /home/stack/ansible-generated/instackenv.yaml
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `tripleo_overcloud_node_import_environment_file` | string | The path to the instackenv file to use

## Inventory requirements

There are no inventory requirements.
