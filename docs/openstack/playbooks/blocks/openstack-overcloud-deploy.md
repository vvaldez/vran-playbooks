# Ansible Playbook: openstack overcloud deploy

This playbook will:

- Create a folder `/home/stack/ansible-generated-logs` on the `director` host to hold output logs
- The `stackrc` file will be sourced and `openstack overcloud deploy {{ tripleo_overcloud_deploy_stack }}` will be ran
- The log output will be placed into `/home/stack/ansible-generated-logs/overcloud-delete-{{ tripleo_overcloud_delete_name }}.log`
- If successful, show the output of `openstack stack list`
- If unsuccessful, show the output `openstack stack failures list`
- If `dcn_export` is `true` then:
  - Clear out or create the `/home/stack/dcn-common` directory
  - Run `openstack overcloud export --stack {{ tripleo_overcloud_deploy_stack }}` to create `/home/stack/dcn-common/control-plane-export.yaml`

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```yml
- name: openstack overcloud deploy central
  import_playbook: ../blocks/openstack-overcloud-deploy.yml
  vars:
    dcn_export: yes
    tripleo_overcloud_deploy_stack: central
    tripleo_overcloud_deploy_networks_file: "{{ site.central.deploy_networks_file }}"
    tripleo_overcloud_deploy_roles_file: "{{ site.central.deploy_roles_file }}"
    tripleo_overcloud_deploy_environment_files: "{{ site.central.deploy_environment_files }}"
```

## Requirements

This playbook has the following collection requirements:

- `tripleo.operator`

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `tripleo_overcloud_deploy_stack` | string | The name of the overcloud stack to deploy
| `tripleo_overcloud_deploy_networks_file` | string | The path on the `director` host to the TripleO networks file to use during deployment
| `tripleo_overcloud_deploy_roles_file` | string | The path on the `director` host to the TripleO roles file to use during deployment
| `tripleo_overcloud_deploy_environment_files` | list | A list of strings. Each list item is the path on the `director` host to an TripleO environment file to use during deployment. **Note:** The order of the list items is respected

The following variables can be optionally set, and have default values, if not set.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `dcn_export` | bool | `false` | Whether to run the `openstack overcloud export` steps after the deployment

## Inventory requirements

No inventory requirements.
