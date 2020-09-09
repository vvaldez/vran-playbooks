ROLE_PATH="${HOME}/.ansible/collections/ansible_collections/oasis_roles/satellite"
rm -rf ${ROLE_PATH}
mkdir -p ${ROLE_PATH}
git clone https://github.com/oasis-roles/ansible_collection_satellite.git ${ROLE_PATH}
ansible-galaxy install -r ${ROLE_PATH}/requirements.yml
