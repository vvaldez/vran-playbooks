#!/bin/bash

THT=/usr/share/openstack-tripleo-heat-templates
CNF=~/templates

openstack overcloud deploy --templates \
-r $CNF/roles_data.yaml \
-n $CNF/network_data.yaml \
-e $THT/environments/services-docker/ironic.yaml \
-e $CNF/environments/net-bond-with-vlans.yaml \
-e $CNF/environments/network-isolation.yaml \
-e $CNF/environments/network-environment.yaml \
-e $CNF/overcloud-images.yaml \
-e $CNF/node-config.yaml \
-e $CNF/storage-environment.yaml \
-e $CNF/ips-from-pool-all.yaml \
-e $CNF/service_net_environment.yaml \
-e $CNF/ironic.yaml
