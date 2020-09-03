#!/usr/bin/env bash

if [ $PWD != $HOME ] ; then echo "USAGE: $0 Must be run from $HOME"; exit 1 ; fi

source ~/stackrc
cd ~

time openstack overcloud deploy \
  --stack {{ loop_index.name_lower }} \
  --templates \
  --timeout 300 \
  -n {{ loop_index.deploy_networks_file}} \
  -r {{ loop_index.deploy_roles_file }} \
  -e {{ loop_index.deploy_environment_files | join (' \\\n  -e ') }} \
  --overcloud-ssh-port-timeout 600 \
  --log-file deployment.log > deploy_{{ loop_index.name_lower }}.log

{% if loop_index.type == 'spine' %}
rm -rf ~/dcn-common
mkdir -p ~/dcn-common
openstack overcloud export \
  --stack {{ loop_index.name_lower }} \
  --output-file /home/stack/dcn-common/control-plane-export.yaml
{% endif %}
