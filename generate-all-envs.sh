#!/bin/bash

paths='
ibm/hosts-gpte
ibm/hosts-kermit
ibm/hosts-test
green/hosts-dev
green/hosts-test
red/hosts-prod
red/hosts-test'
args=''

if [[ ! -z ${1} && ${1} == 'quick' ]]; then
  args='-e template_directory_quick_mode=true'
fi

for path in ${paths}; do
  ansible-playbook \
    -i ../ansible-inventory/${path} \
    pb-generate-templates-locally.yml ${args}
done
