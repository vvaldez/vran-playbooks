# Ansible Role: Tower Config

This role configures a Tower server with various compnents defined via varaibles. This includes:

- Setup Tower CLI
- Configure credentials
- Configure projects
- Configure inventories
- Configure job templates
- Configure workflows

# Requirements

Tower server installed, licensed and registered to RHSM.

## Role Variables

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `tower_host` | string | Tower host to configure | `hostvars[groups['tower'].0].ansible_host` |
| `tower_username` | string | Username to setup as administrator for Tower | `admin` |
| `tower_password` | string | Password for `tower_username` | |
| `tower_config_type` | string | What type of configuration to apply | `Minimal` |
| `tower_config_repos_rhel7` | list | Repositories to enable for RHEL 7 | `[ "rhel-7-server-rpms", "rhel-7-server-ansible-2-rpms", "rhel-7-server-extras-rpms" ]` |
| `tower_config_repos_rhel8` |list | Repositories to enable for RHEL 8 | `[ "rhel-8-for-x86_64-appstream-rpms", "rhel-8-for-x86_64-baseos-rpms", "ansible-2-for-rhel-8-x86_64-rpms" ]` |
| `tower_config_repos` | string | Which list of repositories to use | `tower_config_repos_rhel8` |
| `tower_config_packages_rhel7` | list | Packages to install for RHEL 7 | `[ "ansible", "python-cffi", "python-enum34", "python-idna", "python-paramiko", "python-ply", "python-pycparser", "python2-cryptography", "python2-pyasn1", "sshpass" ]` |
| `tower_config_packages_rhel8` | list | Packages to install for RHEL 8 | `[ "ansible", "python3-cffi", "python3-idna", "python3-ply", "python3-pycparser", "python3-cryptography", "python3-pyasn1", "sshpass", "python2-pip", "python3-pip" ]` |
| `tower_config_packages` | string | Which list of packages to use |  `tower_config_packages_rhel8` |
| `tower_config_pip` | list | Pip packages to install | `[ "ansible-tower-cli" ]` |
| `tower_org` | string | Organization to configure | `Default` |
| `tower_credential_ssh` | dictionary | SSH credential to configure | `{ "name": "SSH", "description": "Private SSH Key", "kind": "ssh", "key_data_file": "my_private_key.pem", "username": "root" }` |
| `tower_credential_scm` | dictionary | SCM credential to configure | `{ "name": "SCM", "description": "SCM credentials", "kind": "scm", "username": "my_user", "key_data_file": "my_private_key.pem" }` |
| `tower_project_inventory` | dictionary | Project to configure for inventory | `{ "name": "Inventory", "description": "Inventory project added by Ansible via tower_config role", "type": "git", "url": "ssh://git@github.com/example/inventory.git", "branch": "master", "clean": "yes", "update_on_launch": "no", "delete_on_update": "no" }` |
| `tower_project_code` | dictionary | Project to configure for playbooks and roles | `{ "name": "Code", "description": "Code project added by Ansible via tower_config role", "type": "git", "url": "ssh://git@github.com/example/code.git", "branch": "master", "clean": "yes", "update_on_launch": "no", "delete_on_update": "no" }` |
| `tower_inventory` | dictionary | Inventory to configure | `{ "name": "Inventory", "description": "Inventory added by Ansible via tower_config role" }` |
| `tower_inventory_source` | dictionary | Inventory sourced from project to configure | `{ "name": "Example inventory source", "description": "Inventory source added by Ansible via tower_config role", "inventory": "{{ tower_inventory.name }}", "source": "scm", "source_project": "{{ tower_project_inventory.name }}", "update_on_launch": true, "update_on_project_update": true, "overwrite": true }` |
| `tower_job_template` | dictionary | Job template to initially configure | `{ "job_type": "run", "inventory": "{{ tower_inventory.name }}", "project": "{{ tower_project_code.name }}", "credential": "{{ tower_credential_ssh.name }}", "verbosity": 0 }` |
| `tower_config_job_templates` | list | List of additional job templates to configure | `[ { "name": "Deploy Director", "playbook": "deploy_undercloud.yml" }, { "name": "Deploy OpenStack", "playbook": "deploy_openstack.yml" }, { "name": "Deploy KVM Hypervisor", "playbook": "deploy_kvm_hypervisor.yml" }, { "name": "Deploy Tower", "playbook": "deploy_tower.yml" }, { "name": "Deploy Container Registry", "playbook": "deploy_container_registry.yml" }, { "name": "Teardown All", "playbook": "teardown.yml" } ]` |
| `tower_config_workflow_template_deploy` | dictionary | Workflow template to initially configure | `{ "name": "Deploy All", "description": "Deploy all components" }` |

## Inventory Requirements

None.

## Authentication

Set the variables `tower_username` and `tower_password`. This should be handled via Ansible Vault for security.
