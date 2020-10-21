[ansible-playbooks/docs/ansible-inventory.md](https://gitlab.consulting.redhat.com/vran/ansible-playbooks/-/blob/master/docs/ansible-inventory.md)

# Add a new composable role

Roles are defined at `overcloud.roles` in `group_vars/openstack/openstack.yml`

Roles are defined as such:

```yml
overcloud:
  ...
  roles:
    ...
    compute_vdu:
      name_upper: # Upper case name used to generate overcloud templates
      name_lower: # Lower case name used to generate overcloud templates
      roles_file: # Path to a YAML file containing the composable role definition
      nic_config_file: # Path to a YAML file containing the nic mapping configuration
```

e.g.

```yml
overcloud:
  ...
  roles:
    ...
    controller:
      name: Controller
      name_lower: controller
      roles_file: "./tewksbury1/templates/profiles/roles_data/controller.yaml"
      nic_config_file: "./tewksbury1/templates/profiles/nic-configs/controller.yaml"
```

**Note**: Both YAML files pointed to above are ran thru the Ansible template module. And have access to some unique variables.

#### roles_files

For `roles_file` the end output result will be a copy of the file per site, with the filename
appended by the site name. i.e. `controller-central.yaml`, `controller-edge1.yaml`, `controller-edge2.yaml`, etc.

Special variables:

- `loop_index`: This is the dictionary for the site currently being acted on. i.e. `site.central`

#### nic_config_file

For `nic_config_file` the end output result will be a copy of the file per role, per site. With the filename
matching the format of `nic-<role.name_lower>-<site.name_lower>.yaml`. i.e. `nic-compute-sriov-central.yaml`, `nic-compute-sriov-edge1.yaml`, `nic-compute-sriov-edge2.yaml`, etc.

Special variables:

- `loop_index[0]`: This is the dictionary for the site currently being acted on. i.e. `site.central`
- `loop_index[1]`: This is the dictionary for the role currently being acted on. i.e. `overcloud.role.controller`

To add a new role you could copy an existing role dictionary and edit the values to match accordingly. The role can then be referenced when defining a site.
i.e. `site.central.roles.<new_role_key>`
