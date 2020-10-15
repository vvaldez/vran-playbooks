# Host OS

## Key trust with OpenStack Director

The `awx` user on the Tower machine must be able to passwordlessly log into the OpenStack Director machine as `stack`.

To accomplish this:
* Generate an SSH keypair for the `awx` user (`ssh-keygen`)
* Copy the public key to `authorized_keys` in the SSH profile of the `stack` user on the OpenStack Director machine (`ssh-copy-id -i ~/.ssh/id_rsa.pub stack@director`)

# Settings

* Job Isolation should be disabled (Settings -> Jobs). Failure to do this will cause the OSP TripleO dynamic inventory to not have access to key trusts built for the `awx` user.

# Projects

Tower should have two Git repositories added as projects:

* Playbook/role repository: `ansible-playbooks` or similar
* Inventory repository: `ansible-inventory` or similar

# Credential Types

## Out of Band
There should be a custom credential type that exposes `oob_username` and `oob_password` as Extra Variables for use with out-of-band management activities.

# Credentials

## Source Control

There should be a credential that connects to the Git SCM hosting the projects listed in *Projects*.

## Machine

### OpenStack heat-admin

There should be a credential using `heat-admin` as its username, with the SSH Private Key copied from the `stack` user on the OpenStack Director.

Used with:

* FPGA Setup

### TOR switches

There should be a credential with a username/password capable of logging into the TOR switch devices via SSH to make configuration changes.

If this user requires `enable` to make configuaration changes, set the enable password as the "Privilege Escalation Password" and select "enable" for "Privilege Escalation Method".

Used with:

* TOR Networking (all)

## Out of Band Management

There should be a credential using the Out of Band custom type (above) to provide access to OOB managers (iDRAC and similar).


# Inventory

## OpenStack TripleO

Create an Inventory Script with the following contents:

```
#!/bin/bash
run_cmd="source stackrc; tripleo-ansible-inventory --list --stack \$(openstack stack list -f value -c 'Stack Name' | tr '\n' ',')"
ssh -Tq stack@director $run_cmd
```

Use this script as a Source for this Tower inventory. Ensure that `director` is replaced by something that resolves in your environment.

In the Inventory Variables, include:

```
ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p -q stack@director"'
```

Again ensure that `director` is replaced by something that resolves in your environment.

Used with:

* FPGA Setup
