1. Install OS
2. Disable SSH GSSAPIAuthentication if needed ()

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

4. Clear out existing Ceph target if needed:

    ```sh
    ssh root@172.17.118.7
    # On ceph host, get into container
    podman exec -it rbd-target-api /bin/bash
    # Use iscsi gateway CLI
    gwcli

    # Cleanup the previous example
    # Delete disks from target
    iscsi-targets/iqn.2020-08.com.ceph:rhv-igw/disks/ delete rbd/rhv_engine_disk
    iscsi-targets/iqn.2020-08.com.ceph:rhv-igw/disks/ delete rbd/rhv_data_disk
    # Delete target
    iscsi-targets/ delete iqn.2020-08.com.ceph:rhv-igw
    # Delete disks
    disks/ delete rbd/rhv_engine_disk
    disks/ delete rbd/rhv_data_disk
    ```

5. Define RHV iscsi Targets in `ansible-inventory/tewksbury1/inventory/group_vars/ceph/rhv_iscsi_targets.yml`

    ```yaml
    ceph:
      iscsi_targets:
        targets:
          - name: iqn.2020-08.com.ceph:rhv-igw
        gateways:
          # Gateways should be added in multiples of 2, and one of these must be the server used to add the targets
          - name: "{{ groups.ceph.0 }}"
          - name: "{{ groups.ceph.1 }}"
          - name: "{{ groups.ceph.2 }}"
        images:
          - name: rhv_engine
            description: Hosted Engine
            size: 200g
          - name: rhv_data
            description: VM Data
            size: 2t
    ```
6. Create targets:

    ```sh
    ansible-playbook \
      -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
      playbooks/ceph/configure_iscsi_targets.yml
    ```

7. Update `ansible-inventory/tewksbury1/inventory/group_vars/rhv/rhv.yml` with wwid of drives

    ```
    ansible-playbook \
      -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
      -e iscsi_target="iqn.2020-08.com.ceph:rhv-igw" \
      -e iscsi_size=200G \
      playbooks/rhv/get_ceph_facts/get_iscsi_wwid.yml

    ansible-playbook \
      -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
      -e iscsi_target="iqn.2020-08.com.ceph:rhv-igw" \
      -e iscsi_size=2T \
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
            iscsi_lun_id: <2T>
            ...
    ```

8. Run `playbooks/rhv/create/installation.yml` to install the RHV hosted engine and additional hosts:

    ```sh
    # Initial installation of hosted engine
    # This currently fails on first run due to networking hang; need to reboot the node via iDRAC.
    ansible-playbook \
      -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
      -e setup_nics=yes \
      playbooks/rhv/create/installation.yml

    # Prep additional hosts for configuration
    ansible-playbook \
      -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
      -e setup_nics=yes \
      playbooks/rhv/create/installation.yml \
      --skip-tags install \
      --limit rhv-2.escwq.com,rhv-3.escwq.com
    ```

9. Run `playbooks/rhv/create/configuration.yml` to configure hosts, storage, disks, networks, etc for RHV:

    ```sh
    ansible-playbook \
      -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
      playbooks/rhv/create/configuration.yml
    ```

10. Run `playbooks/rhv/create/vms.yml` to launch virtual machines:

    ```sh
    ansible-playbook \
      -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
      playbooks/rhv/create/vms.yml
    ```
