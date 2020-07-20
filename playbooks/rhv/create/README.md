1. Install OS
2. Disable SSH GSSAPIAuthentication

    ```
    sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
    systemctl restart sshd
    ```

3. Ansible SSH access

    ```sh
    ssh-keygen -f "/home/homeski/.ssh/known_hosts" -R 172.17.118.1
    ssh-keygen -f "/home/homeski/.ssh/known_hosts" -R 172.17.118.3
    ssh-keygen -f "/home/homeski/.ssh/known_hosts" -R 172.17.118.5
    ssh-copy-id root@172.17.118.1
    ssh-copy-id root@172.17.118.3
    ssh-copy-id root@172.17.118.5
    ```

4. Create and clear out existing Ceph target

    ```sh
    ssh root@172.17.118.7
    # On ceph host, get into container
    podman exec -it rbd-target-api /bin/bash
    # Use iscsi gateway CLI
    gwcli

    # Cleanup the previous example
    # Delete disks from target
    iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/disks/ delete rbd/rhv_engine_disk
    iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/disks/ delete rbd/rhv_data_disk
    # Delete target
    iscsi-targets/ delete iqn.2020-06.com.ceph:12345:rhv-igw
    # Delete disks
    disks/ delete rbd/rhv_engine_disk
    disks/ delete rbd/rhv_data_disk

    # Create target
    iscsi-targets/ create iqn.2020-06.com.ceph:12345:rhv-igw
    # Create gateways
    /iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/gateways create ceph-1.lab.roskosb.info 192.168.170.7
    /iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/gateways create ceph-2.lab.roskosb.info 192.168.170.8
    # Create disks
    /disks create rbd image=rhv_engine_disk size=200g
    /disks create rbd image=rhv_data_disk size=1T
    # Add disks to target
    /iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/disks add rbd/rhv_engine_disk
    /iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/disks add rbd/rhv_data_disk
    # Setup target authentication
    iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/hosts auth disable_acl
    iscsi-targets/iqn.2020-06.com.ceph:12345:rhv-igw/ auth rhv-user ceph-rhv-user
    ```

5. Update `ansible-inventory/vran/hosts/group_vars/rhv.yml` with wwid of drives

    ```
    ansible-playbook \
      -i ../ansible-inventory/vran/hosts/tewksbury.yml \
      -e iscsi_target="iqn.2020-06.com.ceph:12345:rhv-igw" \
      -e iscsi_size=200G \
      playbooks/rhv/get_ceph_facts/get_iscsi_wwid.yml

    ansible-playbook \
      -i ../ansible-inventory/vran/hosts/tewksbury.yml \
      -e iscsi_target="iqn.2020-06.com.ceph:12345:rhv-igw" \
      -e iscsi_size=1T \
      playbooks/rhv/get_ceph_facts/get_iscsi_wwid.yml
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

6. Run `playbooks/rhv/create/installation.yml` to install the RHV hosted engine and additional hosts:

    ```sh
    # Initial installation of hosted engine
    # This currently fails on first run due to networking hang; need to reboot the node via iDRAC.
    ansible-playbook \
      -i ../ansible-inventory/vran/hosts/tewksbury.yml \
      -e setup_nics=yes \
      playbooks/rhv/create/installation.yml

    # Install additional hosts
    ansible-playbook \
      -i ../ansible-inventory/vran/hosts/tewksbury.yml \
      -e setup_nics=yes \
      playbooks/rhv/create/installation.yml \
      --skip-tags install \
      --limit rhv-2.escwq.com,rhv-3.escwq.com
    ```

7. Run `playbooks/rhv/create/configuration.yml` to configure hosts, storage, disks, networks, etc for RHV:

    ```sh
    ansible-playbook \
      -i ../ansible-inventory/vran/hosts/tewksbury.yml \
      playbooks/rhv/create/configuration.yml
    ```

8. Run `playbooks/rhv/create/vms.yml` to launch virtual machines:

    ```sh
    ansible-playbook \
      -i ../ansible-inventory/vran/hosts/tewksbury.yml \
      playbooks/rhv/create/vms.yml
    ```
