#!/usr/bin/env bash

if [ $PWD != $HOME ] ; then echo "USAGE: $0 Must be run from $HOME"; exit 1 ; fi

source ~/stackrc
cd ~

time openstack overcloud deploy \
  --stack {{ current_site.name_lower }} \
  --templates \
  --timeout 300 \
  -n {{ current_site.deploy_networks_file}} \
  -r {{ current_site.deploy_roles_file }} \
  -e {{ current_site.deploy_environment_files | join (' \\\n  -e ') }} \
  --overcloud-ssh-port-timeout 600 \
  --log-file deployment.log > deploy_{{ current_site.name_lower }}.log

{% if current_site.type == 'spine' %}
rm -rf ~/dcn-common
mkdir -p ~/dcn-common
openstack overcloud export \
  --stack {{ current_site.name_lower }} \
  --output-file /home/stack/dcn-common/control-plane-export.yaml
{% endif %}
