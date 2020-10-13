## What is this

At a high level, a reference architecture for deploying and managing the lifecycle of Red Hat OpenStack Platform director deployed OpenStack cloud using Red Hat Ansible.

This framework has been created to be generic enough to be used to jumpstart deploying and managing OpenStack clusters using Ansible. It does not aim to be an all-in-one deployment tool though. Infrastructure, storage, networking, architectures, etc. are always unique across, that's why consulting services are in need, for the individualized problem solving. That does not mean that we cannot distill the actions that are typically taken to deploy and manage OpenStack infrastructure into a framework, which is what this is.

## Components

- **[ansible-inventory](ansible-inventory.md)**: This is implentation specific code. This holds your variables, secrets, host configuration, etc.
- **[ansible-playbooks](ansible-playbooks.md)**: This is the Ansible code doing the work. Here you find playbooks, roles, collections, that are generalized enough to be freely shared and contributed to. Everything in here consumes the configuration as code defined within `ansible-inventory`.

## How to use

Please read in order the documents provided above. They aim to walk a user through settting up a development environment, understanding the structure of the two main components above, and using the framework.

Want to incorporate an existing deployment into using this framework? Read the documentation above.

Want to try out this framework in a sample environment? Provided within `ansible-inventory` is code to spin up virtual OpenStack environments using Vagrant, as long as you have meeting some minimal hardware requirements with [qemu](https://www.qemu.org/)/[libvirt](https://libvirt.org/) installed. Again, the above documents cover how to setup and use the included samples.

## Ansible Playbooks

Each playbook is documented with the following information:

- Tasks
- Usage
- Requirements
- Playbook variables
- Inventory requirements

Playbooks are currently grouped by usage. There are 3 main groups: **Add**, **Delete**, and **Update**. These are meant to be playbooks that perform a set of tasks that are needed to complete a day-2 operation.

Another group, **Blocks**, has more playbooks. These playbooks are to be thought of as functions. They each have playbook variables that need to be defined to be ran. They are consumed as `import_playbook` tasks in any of the 3 playbook groups above.

- [ansible-generated-templates-generate-locally](ansible-generated-templates-generate-locally.md)
- [ansible-generated-templates-upload](ansible-generated-templates-upload.md)
- [install-undercloud](install-undercloud.md)

#### Add

- [add-central-site](add/add-central-site.md)
- [add-edge-site](add/add-edge-site.md)
- [add-node-to-site](add/add-node-to-site.md)

#### Delete

- [delete-edge-site](delete/delete-edge-site.md)
- [delete-node-from-site](delete/delete-node-from-site.md)

#### Update

- [update-site](update/update-site.md)

#### Blocks

- [add-director-to-site-group](blocks/add-director-to-site-group.md)
- [generate-instackenv](blocks/generate-instackenv.md)
- [openstack-aggregate-create](blocks/openstack-aggregate-create.md)
- [openstack-overcloud-delete](blocks/openstack-overcloud-delete.md)
- [openstack-overcloud-deploy](blocks/openstack-overcloud-deploy.md)
- [openstack-overcloud-node-delete](blocks/openstack-overcloud-node-delete.md)
- [openstack-overcloud-node-import](blocks/openstack-overcloud-node-import.md)
- [openstack-overcloud-node-introspect](blocks/openstack-overcloud-node-introspect.md)
- [openstack-undercloud-install](blocks/openstack-undercloud-install.md)
- [openstack-undercloud-upgrade](blocks/openstack-undercloud-upgrade.md)
- [tempest-run](blocks/tempest-run.md)

## User documentation

There is more documentation within the `_docs` folder. These docs will refer to operational docs on how to perform certain tasks. For ease, we'll point to them here:

- [Setup a local development environment](setup.md)
- [ansible-inventory structure and documentation](ansible-inventory.md)
- [How to add an edge site](_docs/add-site.md)
- [How to add a node to a site](_docs/add-node.md)
- [How to add a new compute role](_docs/add-role.md)
- [How to delete an edge site](_docs/delete-site.md)
- [How to delete a node from a site](_docs/delete-node.md)

# Developer Workflow

Envisioned developer workflow goes as follows:

1. Developer pulls down `ansible-inventory.git:master` and `ansible-playbooks.git:master` repositories locally. (Or works on jumpbox)
2. Developer creates either a feature or personal branch to make changes.
3. Developer checks out new branch.
4. Developer makes changes to `ansible-inventory.git`/`ansible-playbooks.git`.
5. When satisfied, developer pushes changes to new branch.
6. Developer submits a pull request from new branch to `master` branch.
7. Lead approves/rejects pull requests. Repeat until steps 4 - 7 until necessary.
8. Master is always referenced as current, working, code.

# Ansible Vault

Ansible Vault is used to encrypt sensitive strings in the `ansible-inventory/` repository. `./vault_secret` in the `ansible-playbooks/` repository must contain the secret string to decrypt the sensitive strings:

```sh
echo '<secret string>' > ./vault_secret
```

The playbooks must be ran with `--vault-password-file ./vault_secret` as arguments

```sh
... --vault-password-file ./vault_secret
```

### Generate a new vault string

1. Make sure the `./vault_secret` file is populated correctly

2. Generate the encrypted YAML key/value

  ```sh
  ansible-vault encrypt_string --vault-id .vault_secret --name 'key' 'secret_value'
  ```

### Encrypt SSL Key to place in `group_vars/` file

```sh
$ cat ssl-key
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----

$ cat ssl-key | ansible-vault encrypt_string --vault-id ./vault_secret --name 'ssl_key'
Reading plaintext input from stdin. (ctrl-d to end input)
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          ...
Encryption successful
```

### Decrypt individual keys

```
$ ansible-vault decrypt
Vault password:
Reading ciphertext input from stdin
$ANSIBLE_VAULT;1.1;AES256
37653465336131656562313865633336393566373832343534313839343966356633366162636163
6362643233363263633537376162343630663332343530630a363236313236653839313236323061
62313466613133326539613865336666633164393961343931353661373564343632393035613264
6266303235663565350a393662393062643738613837313166343066636363656231383334316261
6363
Decryption successful # (ctrl-d to end input)
unencrypted value here

$
```

## Ansible Vault Considerations for Input and Output Templates

The workflow for generating and syncing templates on the Director is such:

1. Populate variable files in `groups_vars/` in `ansible-inventory/` repo.
2. Generate output templates into `ansible-inventory/ansible-generated/`
3. During a playbook run, re-template the files in `ansible-inventory/ansible-generated/` into `/home/stack/ansible-generated/` on the director.

Input templates (from roles or inventory) and output templates in `ansible-inventory/ansible-generated/` are commited into Git. This is a valuable feature, as it allows for changes to input templates, re-generation of output templates, and the quick ability to `diff` the generated templates to see how changes to the input affects the output.

Sensitive strings in the variables files are encrypted using Ansible Vault because they should not be tracked and human readable in Git, or even on the jumpbox itself. Additionally, we do not want the decrypted strings human readable within the output templates held in `ansible-inventory/ansible-generated/`.

For this reason, decryption of sensitive strings **is not performed** during **step 2** above, where output templates get generated into `ansible-inventory/ansible-generated/`. At this step we simply put the place holder for the variable into the output templates. Actual decryption of these senstive strings is **only** performed during **step 3**. The human-readable decrypted strings are then only placed onto the director box within `/home/stack/ansible-generated/`.

Example of an input template `instackenv.yml` utilizing an encrypted string (The actual Jinja2 variable substitution is [escaped](https://jinja.palletsprojects.com/en/2.10.x/templates/#escaping):

```yml
    pm_type: {{ instackenv.pm.type }}
    pm_user: {{ '{{' }} instackenv.pm.user }}
    pm_password: '{{ '{{' }} instackenv.pm.password }}'
```

Example of the generated output template in `ansible-inventory/ansible-generated/instackenv.yml`:

```yml
    pm_type: pxe_ipmitool
    pm_user: {{ instackenv.pm.user }}
    pm_password: '{{ instackenv.pm.password }}'
```

Example of the final generated file on the directory within `/home/stack/ansible-generated/instackenv.yml`:

```yml
    pm_type: pxe_ipmitool
    pm_user: secret_user
    pm_password: 'secret_password'
```

Because decryption is only performed in **step 3**, that is the only step when it is necessary to pass in the decryption password using ``--vault-password-file ./vault_secret``.
