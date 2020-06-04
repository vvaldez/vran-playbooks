# ansible-inventory

This guide aims to provide instructions of how to structure and prepare the the [ansible-inventory](https://gitlab.consulting.redhat.com/openstack-cop/ansible-bundle/ansible-inventory) repository to deploy your own environment.

The goal is to provide some hints to use `ansible-inventory`. The idea is to avoid the need for you to write from scratch all templates. You could re-use some of the templates and variables already prepared in the sample `ansible-inventory` repository.

One of the key features of this repository is the ability to parameterize tripleo templates using Jinja2 syntax and then using the Ansible template module to generate output templates. This ability creates the ability to more easily manage numerous openstack clusters than handling static tripleo templates. We'll cover this in more detail in the following documentation.

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

This the the main location of variables, as ansible practices, they are named per the group name of host name.

```
1. <environment>/hosts/group_vars/all.yml
2. <environment>/hosts/group_vars/<group>.yml
3. <environment>/hosts/hosts_vars/director.example.com.yml
```

`<environment/hosts/group_vars/all.yml` - Contains general vars for all hosts, list of templates to use for deployment and SSL files. Example here we deploy an environment with SSL, DVR, Fixed IPs for VIPs/Servers, and disable telemetry:

```yml
overcloud:
  stack_name: "overcloud-{{ named_env }}"
  roles_file: /home/stack/ansible-generated/templates/roles_data.yaml
  networks_file: /home/stack/ansible-generated/templates/network_data.yaml
  environment_files:
    - /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml
    - /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-dns.yaml
    - /usr/share/openstack-tripleo-heat-templates/environments/ssl/inject-trust-anchor.yaml
    - /home/stack/ansible-generated/templates/environments/network-environment.yaml
    - /home/stack/ansible-generated/templates/environments/network-isolation.yaml
    - /home/stack/ansible-generated/templates/enable-tls.yaml
    - /home/stack/ansible-generated/templates/ips-from-pool-all.yaml
    - /home/stack/ansible-generated/templates/fixed-ip-vips.yaml
    - /home/stack/ansible-generated/templates/network-config.yaml
    - /home/stack/ansible-generated/templates/neutron-ovs-dvr.yaml
    - /home/stack/ansible-generated/templates/node-config.yaml
    - /home/stack/ansible-generated/templates/overcloud-images.yaml
```

`<environment/hosts/group_vars/<group>.yml` - Networking data for overcloud and undercloud, list of repositories, baremetal node information.
In this example we specify the network information to deploy director.

```yml
undercloud:
  hostname: undercloud.example.com
  local_ip: 172.16.0.1/24
  local_interface: eth0
  overcloud_domain_name: example.com
  masquerade: true
  dhcp_start: 172.16.0.5
  dhcp_end: 172.16.0.63
  inspection_iprange: 172.16.0.64,172.16.0.127
  gateway: 172.16.0.254
  generate_service_certificate: true
  certificate_generation_ca: local

  undercloud_nameservers:
    - 8.8.4.4
    - 8.8.8.8
  undercloud_ntp_servers:
    - 0.rhel.pool.ntp.org
    - 1.rhel.pool.ntp.org
    - 2.rhel.pool.ntp.org
```

`<environment/hosts/host_vars/server-name.yml` - Very specific vars like repositories or hostname.

NOTE: Default variables might not fit all scenarios, add/modify/remove for your environment.

## Generate the templates and deploy

From now on you can use the steps in the main README.md of the ansible-playbooks repository to generate the templates and deploy.

NOTE: if a failure occurs generating a template, for example if you remove the SSL variables because you are deploying a non-ssl environment, and you leave the SSL templates, you will get a failure, there is work in progress to add more validation in the templates to take this into account. You can either remove the templates or even better contribute to include conditions in the templates.
