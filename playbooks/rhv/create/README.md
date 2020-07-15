1. Install OS
2. Setup networking so Ansible can SSH over VLAN 118
3. Disable SSH GSSAPIAuthentication

    ```
    sed -i /etc/ssh/sshd_config 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g
    systemctl restart sshd
    ```

4. Ansible SSH access

    ```sh
    ssh-keygen -f "/home/homeski/.ssh/known_hosts" -R 172.17.118.33
    ssh-copy-id root@172.17.118.33
    ```

5. Create and clear out existing Ceph target

    ```sh
    # On ceph host, get into container
    podman exec -it rbd-target-api /bin/bash
    # Use iscsi gateway CLI
    gwcli

    # Cleanup the previous example
    # Delete disks from target
    iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/disks/ delete rbd/test_engine
    iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/disks/ delete rbd/test_data
    # Delete target
    iscsi-targets/ delete iqn.2020-06.com.ceph:12345:homero3-rhv-igw
    # Delete disks
    disks/ delete rbd/test_engine
    disks/ delete rbd/test_data

    # Create target
    iscsi-targets/ create iqn.2020-06.com.ceph:12345:homero3-rhv-igw
    # Create gateways
    /iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/gateways create ceph-1.lab.roskosb.info 192.168.170.7
    /iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/gateways create ceph-2.lab.roskosb.info 192.168.170.8
    # Create disks
    /disks create rbd image=test_engine size=200g
    /disks create rbd image=test_data size=1T
    # Add disks to target
    /iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/disks add rbd/test_engine
    /iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/disks add rbd/test_data
    # Setup target authentication
    iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/hosts auth disable_acl
    iscsi-targets/iqn.2020-06.com.ceph:12345:homero3-rhv-igw/ auth rhv-user ceph-rhv-user
    ```

6. Update rhv_dev.yml with wwid of drives

    ```
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/rhv/get_ceph_facts/get_iscsi_wwid.yml -e iscsi_target="iqn.2020-06.com.ceph:12345:homero3-rhv-igw" -e iscsi_size=200G
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/rhv/get_ceph_facts/get_iscsi_wwid.yml -e iscsi_target="iqn.2020-06.com.ceph:12345:homero3-rhv-igw" -e iscsi_size=1T
    ```

    ```yml
    rhv:
    he_lun_id: <200G>

    ovirt:
    storage:
        domains:
        - name: data
            ...
            iscsi_lun_id: <1T>
            ...
    ```

7. Run `playbooks/rhv/create/installation.yml` to install the RHV hosted engine

    ```
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/rhv/create/installation.yml -e setup_nics=yes
    ```

8. Run `playbooks/rhv/create/configuration.yml` to configure networks, disks, etc for RHV

    ```
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/rhv/create/configuration.yml
    ```

9. Run `playbooks/rhv/create/vms.yml` to launch virtual machines

    ```
    ansible-playbook -i ../ansible-inventory/vran/hosts/tewksbury.yml playbooks/rhv/create/vms.yml
    ```
