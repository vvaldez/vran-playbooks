```
ansible-playbooks/
    openstack/
        # relative_path_to_templates: templates/{{ datacenter }}
        upload-ansible-generated-templates.yml
        generate-ansible-generated-templates-locally.yml
        templates/
            tewksbury1/
                tasks-to-generate-templates.yml
                shared/
                site-specific/
                etc/

# All includes are relative to the playbook being ran.
```
