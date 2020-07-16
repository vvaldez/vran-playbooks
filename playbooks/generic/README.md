# build_isos.yml

Generate ISO image to use for baremetal boot and place it onto infra server.

1. Add host/group underneath the `baremetal` group in `ansible-inventory/vran/hosts/tewksbury.yml`:

    ```yml
    baremetal:
    children:
        edge2_1:
    hosts:
        rhv-1.escwq.com:
    ```

2. Edit dictionary in hosts_vars file. i.e. `ansible-inventory/vran/hosts/host_vars/<host>.yml`:

    ```yml
    networks:
    mgmt:
        bond:
        name: bond0
        opts: mode=802.3ad
        members:
            - em1
            - em2
        vlan:
        name: vlan118
        id: 118
        physdev: bond0
        interface:
        name: vlan118
        gateway: 172.17.118.254
        netmask: 255.255.255.0
    ```

    **Note**: The IP address is grabbed from the `ansible_host` value.

3. Run the build_iso playbook:

    ```sh
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/generic/build_isos.yml
    ```

4. Run the boot baremetal playbook. **Note**: `--limit` the run to the host/groups you want, it is set for `all` by default!

    ```sh
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/bios/virtualmedia/os_install.yml --limit rhv-1.escwq.com
    ```
