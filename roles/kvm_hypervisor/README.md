# Ansible Role: KVM Hypervisor

This role will configure a RHEL server to host virtual machines via libvirt KVM/QEMU.

## Requirements

Access to repositories and pacakges as defined below.

## Role Variables

Available variables are listed below (see `defaults/main.yml`):

What type of networking to configure. Default is 'linux_bridge'.
    kvm_hypervisor_network_type: "linux_bridge"

Repositories required:

    kvm_repos:
      - rhel-7-server-rpms

Packages required:

    kvm_packages:
      - libvirt
      - libvirt-client
      - libvirt-daemon
      - libvirt-daemon-driver-qemu
      - libvirt-daemon-kvm
      - libguestfs-tools
      - libguestfs-xfs
      - qemu-kvm
      - virt-manager
      - virt-install
      - virt-viewer
      - xorg-x11-apps
      - xauth
      - dejavu-sans-fonts
      - nfs-utils
      - numad
      - numactl
      - tuned
      - NetworkManager-tui
      - nm-connection-editor
      - libsemanage-python
      - policycoreutils-python
      - bridge-utils
      - rsync
      - python-lxml

Services configured:

    kvm_services:
      - libvirtd
      - numad
      - tuned

Bridges to configure and use for libvirt networking:

    kvm_bridges:
      mgmt:
        master: 'mgmt'
        slave: 'em2'
        ip_address: 10.1.1.50/24
        gateway: 10.1.1.254
        dns:
          - 10.1.1.250
          - 10.1.1.251
      provisioning:
        master: 'provisioning'
        slave: 'em1'
        ip_address: 192.160.0.50/24


## Dependencies

RHSM registration for upstream packages and container repositories.

## Example Playbook

    - hosts: kvm_hypervisor
      become: True
      tasks:
      - import_role:
          name: kvm_hyervisor

## License

GPLv3

## Author Information

This role was created in 2020 by the Red Hat consulting team (Vinny Valdez, Sohaib Azed, Ihor Stehantsev)