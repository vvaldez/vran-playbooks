# Adding an edge site

The following variables will be referenced throughout these steps

```sh
site_name="edge2"
```

1. Run the playbook to add the edge site

    ```sh
    ansible-playbook \
        -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
        -e site_name=${site_name} \
        -e node_name=${node_name} \
        playbooks/openstack/remove-node-from-site.yml
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
