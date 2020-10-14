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

### Environment structure

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



### Directory components

- `environment/`: At the top level of `ansible-inventory` is any number of "environment" folders. The names of these folders does not matter. These folders delineate unique environments. They are meant to separate environments that are unique. Let's say we're managing two datacenters. One within IBM cloud which has 3 separate clusters (dev, staging, prod). This could be one environment folder called `ibm/` and then have the different clusters as seperate hosts files.

  But we also have another datacenter we manage, for instance a virtual vagrant environment, this could be another top level environment folder named `vagrant/`. We would then end up with a top level structure looking like:

  ```
  $ tree ansible-inventory/
  ├── ibm/
  │   └── ...
  ├── vagrant/
  │   └── ...
  └── ...
  ```

  Let's take a look at the directory structure within an environment.


  ```
  ├── ibm/ # Top level directory to delineate a unique environment
  │   ├── ansible-generated/ # Output templates folder
  │   │   └── statler/
  │   │       └── ...
  │   ├── hosts/
  │   │   ├── group_vars/ # Group variables folder
  │   │   │   ├── all.yml
  │   │   │   ├── development.yml
  │   │   │   ├── production.yml
  │   │   │   └── ...
  │   │   ├── host_vars/  # Host variables folder
  │   │   │   ├── bastion.example.com.yml
  │   │   │   └── ...
  │   │   ├── hosts-development # Host inventory
  │   │   ├── hosts-production  # ...
  │   │   └── ...
  │   └── templates # Input templates folder
  │       ├── shared      # Shared input templates
  │       │   └── ...
  │       ├── development # Inventory specific input templates
  │       │   └── ...
  │       └── production  # ...
  │           └── ...
  ```

  - `ansible-generated/`: The folder where generated output templates get created to. Nothing in this folder should be touched by a human.

  - `hosts/`: A typical Ansible hosts folder. Where to store ansible inventory files and where the `group_vars/` and `host_vars/` folders are stored.

  - `templates/`: Where to store the Jinja2 parameterized tripleo templates. There should be a `templates/shared/` folder used by defaults. Templates in this folder can be overriden by any `templates/<group>/`. The name of the group should come from the top level group defined in any Ansible host file. This should be the name or environment of the cluster.

  The `generate-all-envs.sh` script and called playbook account for this structure when looking for input templates and generating the output templates.

- `ansible.cfg`: A typical Ansible configuration file. There are two key settings in this file that should be understood:

  ```ini
  [defaults]
  hash_behaviour=merge
  vault_password_file=.vault_secret
  ```

  - `hash_behaviour=merge` gives us the ability to have keys that are dictionaries merge. This [option](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-hash-behaviour) is utilized within this framework. At this point do not change it.

  - `vault_password_file=.vault_secret` all vaulted keys should be encrypted with the password defined in this file.

- `generate-all-envs.sh`: This script will take all input templates and directory structure found within `<environment>/templates/<group>` and copy the directory structure as well as generating the output files into the corresponding folder in `<environment>/ansible-generated/<group>`. Essentially, we copy the directory structure first, then treat each file as a jinja2 template, and generate the output file.

  This script will look for all environments and all groups within it, and generate the according templates. You can also generate a specific group's templates by passing in that inventory file as the single parameter.

  ```sh
  $ ./generate-all-envs.sh # generate templates for all environments and groups
  $ ./generate-all-envs.sh ibm/hosts/hosts-development # generate this specific group's templates
  ```

  There is a special precedence dealing with the `<environment>/templates/shared/` folder. The the output generated from the files in this folder will be overridden by identical files found in any `<environment>/templates/<group>/` folder. This creates the capability to override shared templates with templates that may be very unique to a specific group. This capability should be used as sparingly as possible, if most templates in shared are overridden, it may more sense to break out this group into it's own top level environment folder structure.

- `requirements.txt`: A pip requirement file used to install any Python dependencies.

## Populate your variables

Variables will contain your deployment values, for example, networks, IP addresses and features, to produce the heat tripleo yaml templates for the deployment. These templates contain jinja expressions to set the variable values.

Replace `<group>` with a meaningful name, i.e.: lab, ci. This `<group>` is a group in your Ansible inventory that will have the deployment host, director and overcloud as children.

This the the main location of variables, as Ansible practices, they are named per the group name of host name. Precedence of the files from least to greatest is:

```
1. <environment>/hosts/group_vars/all.yml
2. <environment>/hosts/group_vars/<group>.yml
3. <environment>/hosts/hosts_vars/<host>.yml
```

`<environment>/hosts/group_vars/all.yml` - We use this special variables file to define any "defaults" for variables that apply to all groups. If the same variable is defined in any of the below files, they take precedence.

`<environment>/hosts/group_vars/<group>.yml` - Networking data for overcloud and undercloud, list of repositories, baremetal node information.
In this example we specify the network information to deploy director.

```yml
named_env: <group_name> # A special variable used to name this specific cluster. This should be the identical to the group name.

undercloud: # All variables used to generate any templates needed up to `openstack undercloud install`
  ...

overcloud:  # All variables used to generate tripleo overcloud templates
  ...

instackenv: # All variables used to generate instackenv.yaml file
  ...
```

`<environment>/hosts/host_vars/server-name.yml` - Specific variables to apply to individual Ansible hosts.

## Generate the templates and deploy

From now on you can use the steps in the main README.md of the ansible-playbooks repository to generate the templates and deploy.

NOTE: if a failure occurs generating a template, for example if you remove the SSL variables because you are deploying a non-ssl environment, and you leave the SSL templates, you will get a failure, there is work in progress to add more validation in the templates to take this into account. You can either remove the templates or even better contribute to include conditions in the templates.
