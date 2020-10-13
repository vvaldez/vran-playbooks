# Documentation

## Documents

1. [Setup](setup.md) a development environment.
2. [ansible-inventory](ansible-inventory.md) structure and documentation.
3. [ansible-playbook](ansible-playbook.md) structure and documentation.

## What is this

At a high level, a reference architecture for deploying and managing the lifecycle of Red Hat OpenStack Platform director deployed OpenStack cloud using Red Hat Ansible.

This framework has been created to be generic enough to be used to jumpstart deploying and managing OpenStack clusters using Ansible. It does not aim to be an all-in-one deployment tool though. Infrastructure, storage, networking, architectures, etc. are always unique across, that's why consulting services are in need, for the individualized problem solving. That does not mean that we cannot distill the actions that are typically taken to deploy and manage OpenStack infrastructure into a framework, which is what this is.

## Components

- **[ansible-inventory](ansible-inventory.md)**: This is implentation specific code. This holds your deployment templates, variables, secrets, host configuration, etc.
- **[ansible-playbooks](ansible-playbooks.md)**: This is the Ansible code doing the work. Here you find playbooks, roles, collections, that are generalized enough to be freely shared and contributed to. Everything in here consumes the configuration as code defined within `ansible-inventory`.

## How to use

Please read in order the documents provided above. They aim to walk a user through settting up a development environment, understanding the structure of the two main components above, and using the framework.

Want to incorporate an existing deployment into using this framework? Read the documentation above.

Want to try out this framework in a sample environment? Provided within `ansible-inventory` is code to spin up virtual OpenStack environments using Vagrant, as long as you have meeting some minimal hardware requirements with [qemu](https://www.qemu.org/)/[libvirt](https://libvirt.org/) installed. Again, the above documents cover how to setup and use the included samples.
