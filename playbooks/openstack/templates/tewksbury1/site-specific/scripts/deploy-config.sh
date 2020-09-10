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
  --log-file deployment.log \
  --config-download-only

{% if current_site.type == 'spine' %}
rm -rf /home/stack/dcn-common/*
openstack overcloud export \
  --stack {{ current_site.name_lower }} \
  --output-file /home/stack/dcn-common/control-plane-export.yaml
{% endif %}
