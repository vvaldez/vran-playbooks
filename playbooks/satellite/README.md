# satellite

#### Ensure you have installed the roles and collections necessary for these playbooks as define in the README.md in the ansible-playbooks folder
To deploy a Satellite server

1. Add a host to the `satellite` group in `ansible-inventory/<site>/inventory/infra.yml`:

    ```yml
    satellite:
      hosts:
        satellite.escwq.com:
    ```

2. Optionally add an SSH public key to inventory e.g. `ansible-inventory/<site>/inventory/group_vars/all/vars.yml`:

    ```yml
    ssh_keys:
      - "<key1>..."
      - "<key2>..."
      - "<keyN>..."
    ````

3. Review/modify Satellite group variables in `ansible-inventory/<site>/inventory/group_vars/satellite/`

    ```yml
    satellite:
      organization: Default
      location: Tewksbury
      manifest:
        state: present
        # manifest states accepted: absent, present, refreshed
        filename: manifest_20191112T151114Z.zip
        remote_prefix: http://172.17.118.15/satellite/
        temp_dir: ~/.ansible/tmp/
    ```

4. Define the KVM VM details for the host. **Note**: password is optional as an SSH key is injected. e.g. `ansible-inventory/<site>/inventory/host_vars/<host>.yml`:

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

5. Define Satellite details for the host. e.g. `ansible-inventory/<site>/inventory/host_vars/<host>.yml`:

    ```yml
    satellite:
      server_url: https://172.17.118.8/
    ```

6. Define sensitive data. For Tower this will be provided by Tower Credentials. For non-Tower use, create a file and populate it with these variables. (for best practice secure your file with `ansible-vault` or some other secure storage method). e.g. `secrets.yml`:

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
    kvm_vm_password: <vm root password>
    ```

7. Create KVM VM **Note**: Inclusion of secrets file via `-e @secrets.yml`:

    ```sh
    $ ansible-playbook -i ../ansible-inventory/tewksbury1/inventory/infra.yml -e @secrets.yml playbooks/kvm/create/domain_satellite.yml
    ```

8. Install Satellite **Note**: Limit hosts to operate on via `--limit`:

    ```sh
    $ ansible-playbook -i ../ansible-inventory/tewksbury1/inventory/infra.yml -e @secrets.yml --limit satellite.escwq.com playbooks/satellite/create/install_satellite.yml
    ```

9. Configure Satellite **Note**: Limit hosts to operate on via `--limit`:

    ```sh
    $ ansible-playbook -i ../ansible-inventory/tewksbury1/inventory/infra.yml -e @secrets.yml --limit satellite.escwq.com playbooks/satellite/create/configure_satellite.yml
    ```

10. If needed teardown Satellite **Note**: Limit hosts to operate on via `--limit`. **Note2**: Manually unregister from rhsm if desired, this is not currently automated:

    ```sh
    $ ansible-playbook -i ../ansible-inventory/tewksbury1/inventory/infra.yml -e @secrets.yml --limit satellite.escwq.com playbooks/kvm/destroy/domain_satellite.yml
    ```

## Known issues

Subscription Pool Ids are generated when the manifest is imported to the satellite. This means they are unique to the each satellite. The Subscription Pool IDs in this inventory won't work on your satellite.

This playbook will fail on creating activation keys, and will output your ACTUAL Pool IDs like this:

```json
TASK [fail] ************************************************************************************************************
Friday 04 September 2020  05:21:08 -0400 (0:00:00.075)       0:00:13.638 ******
fatal: [satellite.escwq.com]: FAILED! => {"changed": false, "msg": ["There was a failure while creating activation keys.\nThis is often related to incorrect Pool IDs.\nPlease review the output below and update the Pool Ids in\nthe Inventory in the Activation Keys section to use these values.\nThen re-run this playbook with --tags activation-keys\n", ["osp16_containers1 -> 2c91f6887455b0fc017455ba8e9a1658", "Red Hat Hyperconverged Infrastructure for Cloud, Supported (Up to 72TB, with RHEL Guests, NFR) -> 2c91f6887455b0fc017455ba4ca90dde", "Red Hat Hyperconverged Infrastructure for Virtualization, Standard (3-node pod, NFR) -> 2c91f6887455b0fc017455ba4b230dc4", "Red Hat OpenStack Platform, Standard Support (4 Sockets, NFR, Partner Only) -> 2c91f6887455b0fc017455ba4c820dcf"]]}
```

Use the output generated by the playbook to update your satellite inventory in the activation keys.  Update all activation keys. Pool IDs will look very simiar, but not identical.

After the Pool IDs have been updated in the Satellite inventory, re-run this playbook and add:

```
--tags activation-keys
```
