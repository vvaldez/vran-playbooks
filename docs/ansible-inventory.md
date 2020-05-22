# Getting started

This guide aims to provide instructions of how to prepare the variables in the ansible-inventory repository to deploy your own environment. 

Instructions of how to deploy, and contribute are described in main README.rd file in the ansible-playbooks repository. 

The goal is to provide some hints to use ansible-inventory, but a broader getting started documentation with contributions guidelines and automation scripts will be prepared to build a full test environment.

The idea is to avoid make you write from scratch all templates, you could re-use some of the templates and variables already prepared in ansible-inventory directories that were built for automation.

## Where to deploy
If you already have a virtual or baremetal environment you can use this framework to deploy.

Ideally you will store and run these playbooks from your laptop or from a server with SSH access to the servers that will host the OSP infrastructure, from now on named as the "deployment node".

## Requirements
Make sure to have installed python3 and also recommended python3-virtualenv

### Pulling down repositories
```
git clone ssh://git@gitlab.consulting.redhat.com:2222/openstack-cop/ansible-bundle/ansible-playbooks.git
git clone ssh://git@gitlab.consulting.redhat.com:2222/openstack-cop/ansible-bundle/ansible-inventory.git
```

### Installing Ansible and dependencies
As a good practice, install components in an isolated place to avoid breaking other python deps from other tools in the deployment node.
```
$ virtualenv osp
$ source osp/bin/activate
$ pip3 install -r ansible-playbooks/requirements.txt
```

### Clone and install tripleo-ansible-operator
```
git clone https://opendev.org/openstack/tripleo-operator-ansible
cd tripleo-operator-ansible/
ansible-galaxy collection build --force --output-path ~/collections
ansible-galaxy collection install --force ~/collections/tripleo-operator*
```

## Main directories and files 
There are two main locations, one for your variables and other for your templates, replace `dc-name` with a meaningful name that indicates where is your deployment.
```
cd ~/ansible-inventory
dc-name/{group_vars,host_vars} 
dc-name/templates/{shared,lab}
```

The ansible inventory file will be place here
```
dc-name/hosts
```
NOTE: Again, you do not need to create all these, you can copy all from the `vagrant` directory in the ansible-inventory repo to get started and modify accordingly.

## Populate your variables
Variables will contain your deployment values, for example, networks, IP addresses and features, to produce the heat tripleo yaml templates for the deployment. These templates contain jinja expressions to set the variable values.

Replace `env-name` with a meaningful name, i.e.: lab, ci. This `env-name` is a group in your ansible inventory that will have the deployment host, director and overcloud as children.

This the the main location of variables, as ansible practices, they are named per the group name of host name.
```
1. dc-name/group_vars/all.yml
2. dc-name/group_vars/env-name.yml
3. dc-name/hosts_vars/director.example.com.yml
```

all.yml - Contains general vars for all hosts, list of templates to use for deployment and SSL files. Example here we deploy an environment with SSL, DVR, Fixed IPs for VIPs/Servers, and disable telemetry:
```
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

env-name.yml - Networking data for overcloud and undercloud, list of repositories, baremetal node information. 
In this example we specify the network information to deploy director.
```
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

server-name.yml - Very specific vars like repositories or hostname.

NOTE: Default variables might not fit all scenarios, add/modify/remove for your environment.

## Prepare your templates
This is a general view of the templates directory tree, they are named after the default names as in the documentation and contain jinja expressions to format.

```
dc-name/
│ 
── templates                                                              
    ├── env-name
    │   └── templates
    │       └──  # These templates take precedence over shared directory
    └── shared
        ├── instackenv.yaml     # The inventory file
        ├── scripts
        │   └──                 # Bash scripts to deploy, upgrade, delete
        ├── templates  
        │   ├── environments
        │   │   └──             # Default environment templates
        │   ├──                 # Default templates for the deployment
        │   ├── nic-config
        │   │   ├──             # Compute, controller templates
        │   ├── roles_data.yaml # Roles template
        ├── undercloud.conf     # The configuration file to deploy director
```


## Generate the templates and deploy
From now on you can use the steps in the main README.md of the ansible-playbooks repository to generate the templates and deploy.


NOTE: if a failure occurs generating a template, for example if you remove the SSL variables because you are deploying a non-ssl environment, and you leave the SSL templates, you will get a failure, there is work in progress to add more validation in the templates to take this into account. You can either remove the templates or even better contribute to include conditions in the templates.


