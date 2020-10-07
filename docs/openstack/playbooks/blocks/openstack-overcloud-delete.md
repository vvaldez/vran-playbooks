# Ansible Playbook: opensack overcloud delete

This playbook will:

- Create a folder `/home/stack/ansible-generated-logs` on the `director` host to hold output logs
- The `stackrc` file will be sourced and `openstack overcloud delete {{ tripleo_overcloud_delete_name }}` will be ran
- The log output will be placed into `/home/stack/ansible-generated-logs/overcloud-delete-{{ tripleo_overcloud_delete_name }}.log`
- If successful, show the output of `openstack stack list`
- If unsuccessful, show the output `openstack stack failures list`

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```yml
- name: "openstack overcloud delete {{ site_name }}"
  import_playbook: ../blocks/openstack-overcloud-delete.yml
  vars:
    tripleo_overcloud_delete_name: "{{ site_name }}"
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `tripleo_overcloud_delete_name` | string | The name of the overcloud stack to delete

## Inventory requirements

No inventory requirements.
