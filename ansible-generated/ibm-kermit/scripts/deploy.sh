#!/bin/bash

THT=/usr/share/openstack-tripleo-heat-templates
CNF=~/ansible-generated/templates

openstack overcloud deploy --templates \
-r $CNF/roles_data.yaml \
-n $CNF/network_data.yaml \
-e $THT/environments/ceph-ansible/ceph-ansible-external.yaml \
-e $CNF/network-config.yaml \
-e $CNF/environments/network-isolation.yaml \
-e $CNF/environments/network-environment.yaml \
-e $CNF/overcloud-images.yaml \
-e $CNF/node-config.yaml \
-e $CNF/storage-environment.yaml \
-e $CNF/ips-from-pool-all.yaml \
-e $CNF/octavia.yaml \
-e $CNF/service_net_environment.yaml

# -e $CNF/inject-trust-anchor.yaml \
