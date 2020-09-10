# Deleting a compute node from a site

The following variables will be referenced throughout these steps

```sh
# source ~/stackrc
# openstack stack list
site_name="edge2"
# openstack server list
node_name="edge2-computevirtual-0"
```

1. Run the playbook to delete the node

    ```sh
    ansible-playbook \
        -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
        -e site_name=${site_name} \
        -e node_name=${node_name} \
        playbooks/openstack/delete-node-from-site.yml
    ```

2. Make manual modifications to `ansible-inventory/inventory/group_vars` and generate new templates

    - Remove references from `ansible-inventory`

        ```sh
        # Remove reference in `instackenv.nodes`
        vim ansible-inventory/inventory/group_vars/openstack/openstack.yml

        # Decrease count and/or remove role object in `site.roles.<role>.count
        vim ansible-inventory/inventory/group_vars/site_${site_name}>/site.yml`
        ```

    - Generate new templates

        ```sh
        # Generate new templates locally
        cd ansible-inventory/
        ./generate-all-envs.sh
        ```
