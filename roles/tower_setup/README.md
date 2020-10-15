# Ansible Role: Tower Setup

This role will setup a Tower server. This includes:

- Download Tower setup archive file
- Extract Tower setup archive
- Install packages for Tower
- Configure Tower inventory for admin password
- Configure Tower inventory for postgresql password
- Configure Tower inventory for rabbitmq password
- Run Tower setup
- Post Tower license

# Requirements

Server available to SSH to.

## Role Variables

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `tower_host` | string | Tower host to setup | `localhost` |
| `tower_username` | string | Username to setup as administrator for Tower | `admin` |
| `tower_password` | string | Password for `tower_username` | |
| `tower_cli_verbosity` | string | Verbosity to specify with `tower_cli` commands | `--verbose` |
| `tower_pg_password` | string | Password for PosgreSQL | `tower_password` |
| `tower_rabbitmq_password` | string | Password for Rabbitmq | `tower_password` |
| `tower_org` | string | Organization to setup | `Default` |
| `tower_version` | string | Tower version to setup | `3.7.1-1` |
| `tower_rhel_version` | string | RHEL version of the server | `8` |
| `tower_setup_archive_file` | string | Filename of the setup file to obtain | `ansible-tower-setup-bundle-{{ tower_version }}.tar.gz` |
| `tower_setup_archive_dir` | string | Directory that will contain the archive files | This is usually the first part of the filename without the file extension unless "latest" was used e.g. `{{ tower_setup_archive_file.split('.tar.gz').0 }}` |
| `tower_setup_archive_url` | string | URL to the setup archive file | `https://releases.ansible.com/ansible-tower/setup-bundle/{{ tower_setup_archive_file }}` |
| `tower_setup_archive_remote_dir` | string | Directory on Tower server to store the archive during setup | `/tmp` |
| `tower_setup_archive_remote_file` | string | Full path to where archive file will be placed for setup | `{{ tower_setup_archive_remote_dir }}/{{ tower_setup_archive_file }}` |
| `tower_setup_archive_local_file` | string | Local file path on Ansible controller that will be used to copy to Tower | `{{ tower_setup_archive_remote_dir }}/{{ tower_setup_archive_file }}` |
| `tower_setup_repos_rhel7` | list | Repositories to enable for RHEL 7 | `[ "rhel-7-server-rpms", "rhel-7-server-ansible-2-rpms", "rhel-7-server-extras-rpms" ]` |
| `tower_setup_repos_rhel8` |list | Repositories to enable for RHEL 8 | `[ "rhel-8-for-x86_64-appstream-rpms", "rhel-8-for-x86_64-baseos-rpms", "ansible-2-for-rhel-8-x86_64-rpms" ]` |
| `tower_setup_repos` | string | Which list of repositories to use | `tower_setup_repos_rhel8` |
| `tower_setup_packages_rhel7` | list | Packages to install for RHEL 7 | `[ "ansible", "python-cffi", "python-enum34", "python-idna", "python-paramiko", "python-ply", "python-pycparser", "python2-cryptography", "python2-pyasn1", "sshpass" ]` |
| `tower_setup_packages_rhel8` | list | Packages to install for RHEL 8 | `[ "ansible", "python3-cffi", "python3-idna", "python3-ply", "python3-pycparser", "python3-cryptography", "python3-pyasn1", "sshpass", "python2-pip", "python3-pip" ]` |
| `tower_setup_packages` | string | Which list of packages to use |  `tower_setup_packages_rhel8` |

## Inventory Requirements

None.

## Authentication

Set the variables `tower_username`, `tower_password`, `tower_pg_password`, and `tower_rabbitmq_password`. This should be handled via Ansible Vault for security.
