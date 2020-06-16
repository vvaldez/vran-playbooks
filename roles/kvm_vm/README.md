# Ansible Role: KVM VM

This role will create a virtual machine guest on a libvirt KVM hypervisor.

## Requirements

KVM Hypervisor previously setup (see kvm_hypervisor role)

## Role Variables

Available variables are listed below (see `defaults/main.yml`):

Root password to set on VM:

    kvm_vm_root_password: 'password'

Directory for libvirt images:

    kvm_vm_dir: '/var/lib/libvirt/images'

URL for downloading official Red Hat OS images:

    kvm_vm_base_image_url: 'https://access.redhat.com/downloads/content/69/ver=/rhel---7/x86_64/product-downloads'

KVM qcow image filename:

    kvm_vm_base_image: 'rhel-server-7.7-update-1-x86_64-kvm.qcow2'

Localhost location where image file is downloaded and ready:

    kvm_vm_base_image_local: '/tmp/{{ kvm_vm_base_image }}'


Data structure describing the virtual machine details:

    kvm_vm:
      name: 'kvm_vm'
      ram: 8192
      vcpus: 2
      os_variant: 'rhel7'
      disk: 'kvm_vm.qcow2'
      size: '50G'
      hostname: 'kvm_vm'
      domain: 'example.com'
      networks:
        mgmt:
          libvirt: mgmt
          interface: eth0
          ipaddr: '10.1.1.10'
          netmask: '255.255.255.0'
          gateway: '10.1.1.254'
          dns1: '10.1.1.250'
          dns2: '10.1.1.251'
        provisioning:
          libvirt: provisioning
          interface: eth1
          ipaddr: '192.168.0.10'
          netmask: '255.255.255.0'

## Dependencies

KVM Hypervisor role run on target host.

## Example Playbook

    - hosts: kvm_hypervisor
      become: True
      tasks:
      - import_role:
          name: kvm_vm
        vars:
          kvm_vm:
            name: 'director'
            ram: 16384
            vcpus: 4
            os_variant: 'rhel7'
            disk: 'director.qcow2'
            size: '100G'
            hostname: 'director'
            domain: 'example.com'
            networks:
              mgmt:
                libvirt: default
                interface: eth1
                ipaddr: '192.168.122.100'
                netmask: '255.255.255.0'
                gateway: '192.168.122.1'
                dns1: '192.168.122.1'
                dns2: '10.96.0.30'
              provisioning:
                libvirt: provisioning
                interface: eth0
                ipaddr: '172.22.5.59'
                netmask: '255.255.255.0'

## License

GPLv3

## Author Information

This role was created in 2020 by the Red Hat consulting team (Vinny Valdez, Sohaib Azed, Ihor Stehantsev)