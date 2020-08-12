# satellite

To deploy a Satellite server

1. Add a host to the `satellite` group in `ansible-inventory/<site>/inventory/hosts.yml`:

    ```yml
    satellite:
    hosts:
        satellite.escwq.com:
    ```

2. Optionally add an SSH public key to to inventory e.g. `ansible-inventory/<site>/inventory/group_vars/all/vars.yml`:

    ```yml
    ssh_keys:
      - "<key1>..."
      - "<key2>..."
      - "<keyN>..."
    ````

3. Review/modify Satellite gorup variables `ansible-inventory/<site>/inventory/group_vars/satellite/`

    ```yml
    satellite:
      organization: Default
      location: Tewksbury
      manifest:
        state: present
        # manifest states accepted: absent, present, refreshed
        filename: manifest_vRAN_POC_20191112T151114Z.zip
        remote_prefix: http://172.17.118.15/satellite/
        temp_dir: ~/.ansible/tmp/
    ```

4. Define the KVM VM details in the dictionary in hosts_vars file. **Note**: password is optional as an SSH key is injected. e.g. `ansible-inventory/<site>/inventory/host_vars/<host>.yml`:

    ```yml
    kvm_vm_root_password: 'redhat'
    kvm_vm_dir: '/ssd2'
    kvm_vm:
      name: 'satellite'
      ram: 24576
      vcpus: 4
      os_variant: 'rhel7.8'
      disk: 'satellite.qcow2'
      size: '200G'
      hostname: 'satellite'
      domain: '{{ dns_domain }}'
      root_partition: /dev/sda1
      networks:
        management:
          libvirt: mgmt
          vm_interface: eth0
          ipaddr: '172.17.118.8'
          netmask: '255.255.255.0'
          gateway: '172.17.118.254'
          dns1: '{{ nameservers.0 }}'
          dns2: '{{ nameservers.1 }}'
    ```

5. Define Satellite details in the dictionary in hosts_vars file. e.g. `ansible-inventory/<site>/inventory/host_vars/<host>.yml`:

    ```yml
    satellite:
      server_url: https://172.17.118.8/
      admin_username: "{{ satellite_admin_username }}"
      admin_password: "{{ satellite_admin_password }}"
      container_registry_url: "{{ container_registry_url }}"
      container_registry_upstream_username: "{{ container_registry_upstream_username }}"
      container_registry_upstream_password: "{{ container_registry_upstream_password }}"
    ```

6. Define sensitive data. For Tower this will be provided by Tower Credentials. For CLI use define a file and populate it with these variables. (for best practice secure your file with `ansible-vault` or some other secure storage method). e.g. `secrets.yml`:

    ```yml
    ansible_user: root
    rhsm_username: <rhsm_username>
    rhsm_password: <rhsm_password>
    rhsm_pool_ids:
      - <pool1>
      - <pool2>
      - <poolN>
    satellite_admin_username: <satellite_username>
    satellite_admin_password: <satellite_password>
    container_registry_url: https://registry.redhat.io
    container_registry_upstream_username: <registry_username>
    container_registry_upstream_password: <registry_password>
    ```

7. Create KVM VM **Note**: Inclusion of secrets file via `-e @secrets.yml`:

    ```sh
    $ ansible-playbook -i ../ansible-inventory/tewksbury1/inventory/hosts.yml -e @secrets.yml playbooks/kvm/create/domain_satellite.yml
    ```

8. Install Satellite **Note**: Limit hosts to operate on via `--limit`:

    ```sh
    $ ansible-playbook -i ../ansible-inventory/tewksbury1/inventory/hosts.yml -e @secrets.yml --limit satellite.escwq.com playbooks/satellite/create/install_satellite.yml
    ```

9. Configure Satellite **Note**: Limit hosts to operate on via `--limit`:

    ```sh
    $ ansible-playbook -i ../ansible-inventory/tewksbury1/inventory/hosts.yml -e @secrets.yml -l satellite.escwq.com playbooks/satellite/create/configure_satellite.yml
    ```
