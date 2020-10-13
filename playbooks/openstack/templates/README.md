# Template packs

## What are they

"Template packs" are OOO templates bundled into "packs" of static and parameterized jinja2 templates. These packs act as sets of OOO templates that are parameterized and used to generate the final templates eventually placed onto the `director` host.

## Using different template packs

In `ansible-generated-templates-generate-locally.yml` we set the template pack to be used with this variable:

```yml
        relative_path_to_templates: "templates/{{ template_pack }}"
```

And for example in the vran `ansible-inventory` repository, we set inside of `inventory/group_vars/openstack/openstack.yml` the following variable:

```yml
template_pack: vran
```

So whatever `{{ template_pack }}` gets expanded to when `ansible-generated-templates-generate-locally.yml` or `ansible-generated-templates-upload.yml` is ran, that is the template pack that will be used.

## Creating a new template pack

Simply create a new folder inside of `ansible-playbooks/playbooks/openstack/templates/` and make sure `tasks-to-generate-templates.yml` exists. Again, this is a tasks file that is imported into another playbook, so do not write it as a standalone playbook.

Take a look at existing template packs for reference and ideas. It would be simplest to copy an existing template pack and modify it to the new requirements.

## Structure of template packs

Each pack contains an Ansible task file that is ran to do the template generation. This file should be named `tasks-to-generate-templates.yml`.

Template packs can be very tightly coupled to the variables and data structures that they consume, which are held within `ansible-inventory`, so it may be necessary to have access to correlating inventory host files, group_vars, and variables that go along with a template pack to fully understand what is expected.

Let's take a look at the `vran` template pack for example.

```
$ tree vran -L 1 -F
vran/
├── jinja-macros/
├── lookups/
├── role-specific/
├── shared/
├── site-specific/
└── tasks-to-generate-templates.yml
```

The only file absolutely necessary, is `tasks-to-generate-templates.yml` this is an Ansible task file that is imported by `ansible-generate-templates-generate-locally.yml` and used to run the template generation.

Let's take a look at it and break down what it does in parts.

```yml
- set_fact:
    jinja_macros_dir: "{{ relative_path_to_templates }}/jinja-macros/"
    role_specific_dir: "{{ relative_path_to_templates }}/role-specific/"
    shared_dir: "{{ relative_path_to_templates }}/shared/"
    site_specific_dir: "{{ relative_path_to_templates }}/site-specific/"
    tmp_dir: "/tmp/ansible-generated"
    # output_dir should always be passed in
    quick: no
```

Above we set some facts that are used for referencing the file paths. Also note, any facts or variables we set in the task file can be referenced and used inside of templates as well.

```yml
# Define a `site_groups` list that will hold all the groups which
# localhost should be added to `sites`/`overcloud` variable access for
# template generation.
# Initially, we hard code joining the `openstack` group.
- set_fact:
    site_groups: ['openstack']

# Add every group with a name matching `site_*` in `groups` to the
# `site_groups` list.
- set_fact:
    site_groups: "{{ site_groups + [item.key] }}"
  loop: "{{ groups | dict2items }}"
  when: "'site_' in item.key"

# Add localhost to each group in `site_groups`
- add_host:
    name: "{{ inventory_hostname }}"
    groups: "{{ site_groups }}"
```

In the above tasks, we do add the `director` host to all groups matching the pattern `site_*`. This is done because variables only existing the in the `site_*` groups are referenced throughout the Jinja2 templates, but the template generation is actually happening against the `director` host, so we need to temporarily access the variables.

This is special logic for the vran templates. These groups may or may not exist for a different set of template packs. This is an example of one of the first points made in this document, that template packs can be very tightly coupled to the variables and data structures that they consume. So it may be important to compare the template pack against an example inventory developed along side it.

```yml
# Template $shared_dir into $tmp_dir
- include_role:
    name: template-directory
  vars:
    template_directory_input_dir: "{{ shared_dir }}"
    template_directory_output_dir: "{{ tmp_dir }}"
    template_directory_changed_when: false
    template_directory_quick_mode: "{{ quick|bool }}"
  no_log: false

# Template $sites_dir into $tmp_dir
# loop_index is the site dictionary
- include_role:
    name: template-directory
  vars:
    template_directory_input_dir: "{{ site_specific_dir }}"
    template_directory_output_dir: "{{ tmp_dir }}"
    template_directory_changed_when: false
    template_directory_quick_mode: "{{ quick|bool }}"
    template_directory_filename_affix: "-{{ loop_index.name_lower }}"
    current_site: "{{ loop_index }}"
  loop: "{{ sites }}"
  loop_control:
    label: "{{ loop_index.name_upper }}"
    loop_var: loop_index
    index_var: my_idx
  no_log: false

# Template $roles_dir into $tmp_dir
# loop_index[0] is the site dictionary
# loop_index[1].type is the role dictionary
- include_role:
    name: template-directory
  vars:
    template_directory_input_dir: "{{ role_specific_dir }}"
    template_directory_output_dir: "{{ tmp_dir }}"
    template_directory_changed_when: false
    template_directory_quick_mode: "{{ quick|bool }}"
    template_directory_filename_affix: "-{{ loop_index[1].type.name_lower }}-{{ loop_index[0].name_lower }}"
    current_site: "{{ loop_index[0] }}"
    current_site_role: "{{ loop_index[1] }}"
  loop: "{{ sites | subelements('roles') }}"
  loop_control:
    label: "{{ loop_index[0].name_upper }}/{{ loop_index[1].type.name_upper }}"
    loop_var: loop_index
    index_var: my_idx
  no_log: false
```

In the above tasks is where the files in the other folders are consumed:

```
$ tree vran -L 1 -F
vran/
├── jinja-macros/
├── lookups/
├── role-specific/
├── shared/
├── site-specific/
...
```

The `template-directory` role is utilized to take the folder structure of each directory, recreate it, then run each file in the directory (recursively) through the `template` module and put it's output into place.

There are concepts of `shared`, `sites`, and `roles` templates in the vran template pack.

- `shared/`: Templates in this folder are ran thru the `template` module once.
- `site-specific/`: Templates in this folder are ran thru the `template` module once per `site` that exists in the vran inventory.
- `role-specific/`: Templates in this folder are ran thru the `template` module once per `site` and `role` that exists in the vran inventory.

  For example:

  ```yml
  sites:
    - central:
        roles:
          - controller
          - compute-vdu

    - edge1:
        roles:
          - compute-vdu
          - compute-sriov
  ```

  With a datastructure like this, we'd end up with something like:

  ```
  file-controller-central
  file-compute-vdu-central
  file-compute-vdu-edge1
  file-compute-sriov-edge1
  ```

  So we end up with unique files per site, per role.

Now taking a look at the remaining folders:

```
$ tree vran -L 1 -F
vran/
├── jinja-macros/
├── lookups/
...
```

In `lookups/` we simply hold some smaller Jinja2 templates that we re-use within other templates, so of like re-usable blocks or functions. This is just organization to try to keep things as DRY as possible.

In `jinja-macros/` we hold [Jinja2 macros](https://jinja.palletsprojects.com/en/2.11.x/templates/#macros) that are imported to other templates as well. Jinja2 macros are essentially Jinja2 functions that can accept input and provide output, again to help keep templates as DRY as possible.

## Input/ouput files example

Let's take at the full input of the `vran` template pack and compare it to what the output is.

Input:

```
$ tree ansible-playbooks/playbooks/openstack/templates/vran -F
vran
├── jinja-macros/
│   └── get_physnet_mapping.j2
├── lookups/
│   ├── nic-configs/
│   │   ├── compute-sriov.yaml
│   │   ├── compute-vdu.yaml
│   │   ├── compute-virtual.yaml
│   │   └── controller.yaml
│   ├── role-environments/
│   │   ├── compute-sriov-central.yaml
│   │   ├── compute-sriov-edges.yaml
│   │   ├── compute-vdu.yaml
│   │   ├── compute-virtual.yaml
│   │   └── controller.yaml
│   ├── roles-data/
│   │   ├── compute-sriov.yaml
│   │   ├── compute-vdu.yaml
│   │   ├── compute-virtual.yaml
│   │   └── controller.yaml
│   └── site-environments/
│       ├── central-environment.yaml
│       └── edge-environment.yaml
├── role-specific/
│   └── templates/
│       └── network/
│           └── nic.yaml
├── shared/
│   ├── heat/
│   │   └── external_tempest.yaml
│   ├── instackenv.yaml
│   ├── scripts/
│   │   ├── 0-site-settings.sh*
│   │   ├── 1-setup_dell_bios.sh*
│   │   ├── 2-undercloud-prepare-for-install.sh*
│   │   ├── 3.0-satellite.prep.sh
│   │   ├── 3.1-undercloud-install-ospd.sh*
│   │   ├── 3.2-introspection.sh*
│   │   ├── 3.3-create-upload-rt-image.sh*
│   │   ├── 3.4-configure-ceph.sh
│   │   ├── 3.5-Ceph-packages
│   │   ├── _create_roles.sh*
│   │   ├── _map_neutron_ports.sh*
│   │   ├── post-install-routed-provider-nets.sh
│   │   ├── post-install.sh*
│   │   ├── rt.sh
│   │   └── upgrade-prepare-central.sh*
│   ├── tempest.conf
│   ├── templates/
│   │   ├── containers-prepare-parameter.yaml
│   │   ├── environments/
│   │   │   ├── environment-common.yaml
│   │   │   └── external-storage.yaml
│   │   └── network_data.yaml
│   └── undercloud.conf
├── site-specific/
│   ├── scripts/
│   │   ├── deploy-config.sh*
│   │   └── deploy.sh*
│   └── templates/
│       ├── environments/
│       │   └── environment.yaml
│       └── roles_data.yaml
└── tasks-to-generate-templates.yml
```

Output:

```
tree ansible-inventory/tewksbury1/ansible-generated -F
ansible-generated
├── heat/
│   └── external_tempest.yaml
├── instackenv.yaml
├── scripts/
│   ├── 0-site-settings.sh*
│   ├── 1-setup_dell_bios.sh*
│   ├── 2-undercloud-prepare-for-install.sh*
│   ├── 3.0-satellite.prep.sh
│   ├── 3.1-undercloud-install-ospd.sh*
│   ├── 3.2-introspection.sh*
│   ├── 3.3-create-upload-rt-image.sh*
│   ├── 3.4-configure-ceph.sh
│   ├── 3.5-Ceph-packages
│   ├── _create_roles.sh*
│   ├── deploy-central.sh*
│   ├── deploy-config-central.sh*
│   ├── deploy-config-edge1.sh*
│   ├── deploy-config-edge2.sh*
│   ├── deploy-edge1.sh*
│   ├── deploy-edge2.sh*
│   ├── _map_neutron_ports.sh*
│   ├── post-install-routed-provider-nets.sh
│   ├── post-install.sh*
│   ├── rt.sh
│   └── upgrade-prepare-central.sh*
├── tempest.conf
├── templates/
│   ├── containers-prepare-parameter.yaml
│   ├── environments/
│   │   ├── environment-central.yaml
│   │   ├── environment-common.yaml
│   │   ├── environment-edge1.yaml
│   │   ├── environment-edge2.yaml
│   │   └── external-storage.yaml
│   ├── network/
│   │   ├── nic-compute-sriov-central.yaml
│   │   ├── nic-compute-sriov-edge1.yaml
│   │   ├── nic-compute-sriov-edge2.yaml
│   │   ├── nic-compute-vdu-edge1.yaml
│   │   ├── nic-compute-vdu-edge2.yaml
│   │   ├── nic-compute-virtual-central.yaml
│   │   ├── nic-compute-virtual-edge1.yaml
│   │   ├── nic-compute-virtual-edge2.yaml
│   │   └── nic-controller-central.yaml
│   ├── network_data.yaml
│   ├── roles_data-central.yaml
│   ├── roles_data-edge1.yaml
│   └── roles_data-edge2.yaml
└── undercloud.conf
```

The output is much different than the input, but ultimately the output files are what are put onto the `director` host and used for the Director Undercloud and Overcloud deployments.
