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
    git clone ssh://git@gitlab.consulting.redhat.com:2222/<ansible-inventory-repository>
    git clone ssh://git@gitlab.consulting.redhat.com:2222/<ansible-playbooks-repository>
    ```

- Install Python dependencies

    ```sh
    # Install dependencies
    pip install -r ansible-playbooks/requirements.txt
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

  The private key used to connect to all hosts needs to be in place. That the the current host can SSH into systems using key authentication.

- Test Ansible connectivity

    ```sh
    ansible -i ansible-inventory/example/inventory/hosts.yml -m ping director
    ```

    The output should show:

    ```
    director.example.com | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
    }
    ```
