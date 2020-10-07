# Ansible Playbook: Add director to site group

This playbook will:

Create an aggregate named `{{ aggregate_name }}` into the availability zone named `{{ zone_name }}`, if it does not already exist. The `centralrc` file will be sourced to create the resources.

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```sh
- name: openstack aggregate create {{ site_name }}
  import_playbook: ../blocks/openstack-aggregate-create.yml
  vars:
    aggregate_name: "{{ site_name }}"
    zone_name: "{{ site_name }}"
```

## Requirements

This playbook has role/collection dependencies.

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `aggregate_name` | string | The name of the aggregate to create
| `zone_name` | string | The name of the zone to create the aggregate within

## Inventory requirements

No inventory requirements.
