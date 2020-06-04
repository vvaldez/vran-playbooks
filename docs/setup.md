# Setup Development Environment

The following steps walkthrough setting up a development workspace to use and contribute to the automation framework.

- Create a workspace and setup virtualenv

    ```sh
    # Create workspace folder
    mkdir workspace && cd workspace

    # Install virtualenv
    pip install virtualenv

    # Setup environment
    virtualenv venv-ansible
    source venv-ansible/bin/activate
    ```

- Clone the repositories

    ```sh
    git clone ssh://git@gitlab.consulting.redhat.com:2222/osp-novello/ansible-inventory.git
    git clone ssh://git@gitlab.consulting.redhat.com:2222/osp-novello/ansible-playbooks.git
    git clone ssh://git@gitlab.consulting.redhat.com:2222/osp-novello/ansible-elk.git
    git clone ssh://git@gitlab.consulting.redhat.com:2222/osp-novello/ansible-monitoring.git
    ```

- Install Python dependencies

    ```sh
    # Install dependencies
    pip install -r ansible-inventory/requirements.txt
    ```

- Install Ansible dependencies

    ```sh
    ansible-galaxy collection install -r ansible-playbooks/roles/requirements.yml
    ansible-galaxy role install -r ansible-playbooks/roles/requirements.yml
    ```

- Setup Ansible Vault password

    ```sh
    # Replace the echo with the actual password :)
    echo 'super secret password' > ansible-inventory/.vault_secret
    ```

- Place private key

  The private key used to connect to all hosts needs to be in place. All of the hosts files start with these lines:

    ```ini
    [all:vars]
    ansible_user=root
    ansible_ssh_private_key_file=~/.ssh/novello_rsa
    ```

    Make sure that the above private key exists, has the `0644` permissions, and is correct.

- Test Ansible connectivity

    ```sh
    ansible -i ansible-inventory/ibm/hosts/osp-waldorf -m ping director
    ```

    The output should show:

    ```
    director.waldorf.dal10.ole.redhat.com | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
    }
    ```
