kvm
=========

Ansible Role to provision an OpenStack KVM system

Requirements
------------

none

Role Variables
--------------

Dependencies
------------


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: localhost
      connection: local
      gather_facts: no
      vars_prompt:
        - name: prompt_env
          prompt: Confirm the environment to target
          private: no
      tasks:
        - assert:
            that:
              - prompt_env == named_env
            fail_msg: "Incorrect environment entered. {{ prompt_env }} is not {{ named_env }}"
            success_msg: "Targeting {{ prompt_env }} environment"

      tags:
        - always

    - hosts: all
      gather_facts: no
      tasks:
        - import_role:
            name: kvm

License
-------

BSD

Author Information
------------------

Homero Pawlowski - homeski2@gmail.com
