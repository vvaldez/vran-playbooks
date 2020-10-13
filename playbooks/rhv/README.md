1. Install RHEL OS

2. Disable SSH GSSAPIAuthentication (if needed)

    ```
    sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
    systemctl restart sshd
    ```

3. Ansible SSH access [playbooks/generic/add_ssh_keys.yml](../generic/add_ssh_keys.md)

4. Clear out existing Ceph target if needed: [playbooks/ceph/destroy/iscsi_target.md](../ceph/destroy/iscsi_target.md)

5. Define RHV iSCSI Targets in `ansible-inventory/<datacdenter>/inventory/group_vars/ceph/rhv_iscsi_targets.yml`

    ```yaml
    ceph:
      iscsi_targets:
        targets:
          - name: iqn.2020-08.com.ceph:rhv-igw
        gateways:
          - name: "{{ groups.ceph.0 }}"
          - name: "{{ groups.ceph.1 }}"
          - name: "{{ groups.ceph.2 }}"
        images:
          - name: rhv_engine
            description: Hosted Engine
            size: 200G
          - name: rhv_data
            description: VM Data
            size: 2T
    ```
6. Create RHV iscsi Targets in: [playbooks/ceph/create/iscsi_target.md](../ceph/create/iscsi_target.md)

7. Run [installation](create/installation.md) to install the RHV hosted engine and additional hosts

8. Run [configuration](create/configuration.md) to configure hosts, storage, disks, networks, etc for RHV

9. Run [vms](create/vms.md) to launch virtual machines
