# build_isos.yml

Generate ISO image to use for baremetal boot and place it onto infra server.

1. Add host/group underneath the `baremetal` group in `ansible-inventory/<site>/inventory/hosts.yml`:

    ```yml
    baremetal:
    hosts:
        rhv-1.escwq.com:
    ```

2. Edit dictionary in hosts_vars file. e.g. `ansible-inventory/<site>/inventory/host_vars/<host>.yml`:

    ```yml
    install:
    ########## RHEL 8
      os_version: # Set at site_central group level, included here for reference/override
          major: "8"
          minor: "2"
      os_device: '/dev/disk/by-path/pci-0000:86:00.0-ata-1' # notice the difference between RHEL 7 and 8 missing '.0'
      interface:
        # bond name and options are added to site_central group_vars and merged with this members key
        members:
          - eno1
          - eno2
    ########## RHEL 8
    ########## RHEL 7
    #  os_version: # Set at site_central group level, included here for reference/override
    #      major: "7"
    #      minor: "8"
    #  os_device: '/dev/disk/by-path/pci-0000:86:00.0-ata-1.0' # notice the difference between RHEL 7 and 8 uses '.0'
    #  interface:
    #    # bond name and options are added to site_central group_vars and merged with this members key
    #    members:
    #      - em1
    #      - em2
    ########## RHEL 7
    ```

    **Note**: The IP address is grabbed from the `ansible_host` value.

3. Run the build_iso playbook optionally specifying which hosts to build for. By default all hosts in the baremetal group are built:

    ```sh
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/generic/build_isos.yml -e '{ build_iso_hosts: ["rhv-1.escwq.com"]}'
    ```

4. Make sure the node is set to `Legacy` boot mode.

5. Run the boot baremetal playbook. **Note**: `--limit` the run to the host/groups you want:

    ```sh
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/bios/virtualmedia/os_install.yml --limit rhv-1.escwq.com
    ```
