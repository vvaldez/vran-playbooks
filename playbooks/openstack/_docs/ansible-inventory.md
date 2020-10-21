# ansible-inventory

This guide aims to cover the structure and contents of the `ansible-inventory` repository. The repository has many different hosts, groups, and variables. This guide will attempt to cover only hosts, groups, and variables pertaining to OpenStack automation.

## Structure

We'll start at the top level of the repository and work down.

```
$ tree ansible-inventory -F -L 1
ansible-inventory
├── ansible.cfg
├── generate-all-envs.sh*
├── tewksbury1/
└── vagrant/
```

At the top level we have a couple special files and couple directories:

- `ansible.cfg`: Typical Ansible configuration file
- `generate-all-envs.sh`: Shell script that will attempt generate the local output templates for all "environments" found. "Environments" are explained in detail below.
- `tewsbury1`: The tewksbury1 environment
- `vagrant`: The vagrant1 environment

So essentially there are two files and some folders.

Each folder in this top-level directory represents an "environment". Inside of these folders is where you'll find the unique hosts files, groups, group variables, host variables, and the ansible-generated output templates for the unique environment. Environments do not share any data, they are completely separate.

A couple ideas for usage of keeping multiple environments in a single `ansible-inventory` repository:

- Multiple, but different datacenters. Say `dc-east`, `dc-west`, etc
- Separating production environments like `virtual`, `test`, `qa`, `prod`, etc

### Folder structure

For all the following examples we'll be using the `tewksbury1` environment as reference.

Let's take a look at what the structure looks like inside of an environment. For now, we'll also omit files and look only at the directory structure.

```
$ tree ansible-inventory/tewksbury1 -F -d
ansible-inventory/tewksbury1
├── ansible-generated
│   ├── heat
│   ├── scripts
│   └── templates
│       ├── environments
│       └── network
└── inventory
    ├── group_vars
    │   ├── all
    │   ├── ceph
    │   ├── computes
    │   ├── openstack
    │   │   └── roles
    │   ├── rhv
    │   ├── satellite
    │   ├── site_central
    │   ├── site_central_tor
    │   ├── site_edge1
    │   ├── site_edge2
    │   ├── site_edge_tor
    │   ├── site_infrastructure
    │   ├── tor_networking
    │   ├── tower
    │   └── vdu
    └── host_vars
```

There are two top-level folders:

- `ansible-generated/`: This folder holds the generated OOO templates as they would look on the `director` host. All the files in this folder are placed there by Ansible. Do not create or edit any files in the folder manually, as they will be overridden. The files are static, and changes to Ansible group or host variables or input templates will not be reflected until a template generation playbook is ran (local or upload). They need to me manually kept updated and can be done so by running the [generate templates locally playbook](../ansible-generated-templates-generate-locally.md).
- `inventory/`: This is your typical Ansible inventory directory structure. The best resource for information on how to build an Ansible inventory can be found in the upstream docs [here]((https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html).

### Host inventory

Now that we observed the folder structure of the repository, next let's zoom in on the Ansible host inventory and document what relates to the OpenStack automation.


In the following output, any folders or files not relevant to OpenStack have been omitted.
```
ansible-inventory/tewksbury1/inventory
├── group_vars/
│   ├── all/
│   │   ├── oob.yml
│   │   ├── rhsm.yml
│   │   ├── secrets.yml
│   │   ├── sites.yml
│   │   └── vars.yml
...
│   ├── openstack/
│   │   ├── openstack.yml
│   │   └── roles/
│   │       ├── compute-sriov.yaml
│   │       ├── compute-vdu.yaml
│   │       ├── compute-virtual.yaml
│   │       └── controller.yaml
...
│   ├── site_central/
│   │   ├── install.yml
│   │   ├── kvm_vm.yml
│   │   └── site.yml
│   ├── site_central_tor/
│   │   └── vars.yml
│   ├── site_edge1/
│   │   └── site.yml
│   ├── site_edge2/
│   │   └── site.yml
│   ├── site_edge_tor/
│   │   └── vars.yml
...
├── hosts.yml
...
└── infra.yml
```

Essentially, the groups and group variables shown in the output above are needed to successfully generate the output OOO templates from the input templates.

The input templates depend on variables inside of these files to be populated for required logic or variable expansion to happen.

Next, we'll pick out some important variable files and take a look at their contents and structure.

### `openstack` inventory variables

There are a couple key files to point out in the openstack group variables folder.

```
...
│   ├── openstack/
│   │   ├── openstack.yml
│   │   └── roles/
│   │       ├── compute-sriov.yaml
│   │       ├── compute-vdu.yaml
│   │       ├── compute-virtual.yaml
│   │       └── controller.yaml
...
```

Let's start with `openstack/openstack.yml`.

```yml
# This should match a folder name within ansible-playbooks/playbooks/openstack/templates/
template_pack: vran

#################
# Undercloud
#################

undercloud:
  ...

#################
# Overcloud
#################

overcloud:
  ooo:
    ...

#################
# Instackenv
#################

instackenv:
  ...
```

For brevity, we omitted specific variables with `...` in the output above.

First, we set the value of `template_pack: vran`. This sets the template pack to use as input templates. "Template packs" are documented elsewhere, take a look at the main [README](../README.md) for more information. **Note:** Depending on the template pack chosen, that could change what variables are consumed and required to be set.

There are 3 main dictionary keys that exist:

- `undercloud`: This is where we set all variables needed to be set to generate `undercloud.conf` and be able to run the [install-undercloud.yml](../install-undercloud.md) playbook.
- `overcloud.ooo`: This is where we set all variables needed to be able to generate the OOO overcloud templates. The `vran` template pack also consumes a lot of data structures set in the `site_*` groups, and those are also needed as well, but we'll take a look at them later.
- `instackenv`: This is a list where we set the node information of a typical instackenv.yaml file. The details of this list and how to populate it can be found in the `discover` [role documentation](../../../roles/discover/README.md). In the end, this variable is used to generate an `instackenv.yaml`.

There are also some files underneath `openstack/roles/`. These set some variables specific to overcloud "roles" that are also needed for template generation. They are all identical, but have values, so let's pick two and take a look. Let's pick:

- `openstack/roles/compute-sriov.yaml`

  ```yml
  role:
    compute_sriov:
      name_upper: ComputeSriov
      name_lower: compute-sriov
      role_data_file: "{{ relative_path_to_templates | default(omit) }}/lookups/roles-data/compute-sriov.yaml"
      nic_config_file: "{{ relative_path_to_templates | default(omit) }}/lookups/nic-configs/compute-sriov.yaml"
  ```

- `openstack/roles/compute-vdu.yaml`

  ```yml
  role:
    compute_vdu:
      name_upper: ComputeVdu
      name_lower: compute-vdu
      role_data_file: "{{ relative_path_to_templates | default(omit) }}/lookups/roles-data/compute-vdu.yaml"
      nic_config_file: "{{ relative_path_to_templates | default(omit) }}/lookups/nic-configs/compute-vdu.yaml"
  ```

The top level dictionary `role` needs to be set. In the end, all keys the belong to role are merged together.

Then we create any **unique** role we want underneath, for example `compute_sriov`. Each role must have the following keys set:

- `name_upper`: OOO templates need to reference overcloud roles in uppercase and lowercase, depending on the usage. We set the uppercase string to use for the role name here, camel case is preferred.
- `name_lower`: OOO templates need to reference overcloud roles in uppercase and lowercase, depending on the usage. We set the lower string to use for the role name here, all lower case with hypens separating words is preferred.
- `role_data_file`: This needs to be the path to a OOO "role-data" template. Note the usage of a special variable `{{ relative_path_to_templates | default(omit) }}`. This is important, always use this variable as shown and then append the relative path from the "template pack" folder used to the template. e.g. inside the `vran` template pack directory is a path to `./lookups/roles-data/compute-vdu.yaml`. See the template pack documentation for more information.
- `nic_config_file`: This needs to be the path to a OOO "network-config" template. This is important, always use this variable as shown and then append the relative path from the "template pack" folder used to the template. e.g. inside the `vran` template pack directory is a path to `./lookups/nic-configs/compute-vdu.yaml`. See the template pack documentation for more information.

### `site_*` inventory variables
