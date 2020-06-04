# ansible-inventory

This guide aims to provide instructions of how to structure and prepare the the [ansible-inventory](https://gitlab.consulting.redhat.com/openstack-cop/ansible-bundle/ansible-inventory) repository to deploy your own environment.

The goal is to provide some hints to use `ansible-inventory`. The idea is to avoid the need for you to write from scratch all templates. You could re-use some of the templates and variables already prepared in the sample `ansible-inventory` repository.

One of the key features of this repository is the ability to parameterize tripleo templates using Jinja2 syntax and then using the Ansible template module to generate output templates. This creates the ability to more easily manage numerous OpenStakc clusters than handling static tripleo templates. We'll cover this in more detail in the following documentation.

## Where to deploy

If you already have a virtual or baremetal environment you can incorparate your templates into this framework and use it to deploy and manage the environment.

The sample `ansible-inventory` repository includes a demonstration environment based on [Vagrant](https://www.vagrantup.com/) that can be used to spin up a fully virtual OpenStack cluster on a [libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) based hypervisor.

Ideally you will store and run these playbooks from your laptop or from a server with SSH access to the servers that will host the OSP infrastructure, from now on named as the `bastion`.

## Setup

See [setup](setup.md) documentation.

## Structure

The below directory tree attempts a high level overview of the key components of the current directory structure.

```sh
$ tree ansible-inventory/
├── environment_1/ # Top level directory to delineate a unique environment
│   ├── ansible-generated/ # Output templates folder
│   │   ├── development/
│   │   │   └── ...
│   │   └── production/
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
├── environment_2/ # ...
│   └── ...
├── ansible.cfg
├── generate-all-envs.sh # Script to generate output templates
├── README.md
└── requirements.txt # pip requirements
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
