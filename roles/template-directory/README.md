template-directory
=========

Ansible Role to template an entire directory structure efficiently.

Requirements
------------

None.

Role Variables
--------------

template_directory_changed_when: true
template_directory_copy_only: false
template_directory_quick_mode: false

Dependencies
------------

None.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: localhost
      gather_facts: no
      vars:
        pb_tmp_dir: "/tmp/ansible-generated/{{ named_env }}"
        pb_output_dir: "./ansible-generated"
        quick: no
      tasks:
        - name: Ensure {{ pb_tmp_dir }} doesn't already exist
          file:
            path: "{{ pb_tmp_dir }}"
            state: absent
          changed_when: false

        # Template ./roles/osp-templates/templates into $pb_tmp_dir
        - include_role:
            name: osp-templates
          vars:
            osp_templates_input_dir: roles/osp-templates/templates/
            osp_templates_output_dir: "{{ pb_tmp_dir }}"
            osp_templates_changed_when: false
            osp_templates_quick_mode: "{{ quick|bool }}"
          no_log: true

License
-------

BSD

Author Information
------------------

Homero Pawlowski - homeski2@gmail.com
