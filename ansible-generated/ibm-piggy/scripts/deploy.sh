#!/bin/bash

THT=/usr/share/openstack-tripleo-heat-templates
CNF=~/ansible-generated/templates

time openstack overcloud deploy \
--stack overcloud-piggy \
--templates \
-r $CNF/roles_data.yaml \
-n $CNF/network_data.yaml \
-e $THT/environments/ceph-ansible/ceph-ansible-external.yaml \
-e $THT/environments/disable-telemetry.yaml \
-e $CNF/environments/network-environment.yaml \
-e $CNF/environments/network-isolation.yaml \
-e $CNF/ips-from-pool-all.yaml \
-e $CNF/network-config.yaml \
-e $CNF/neutron-ovs-dvr.yaml \
-e $CNF/node-config.yaml \
-e $CNF/octavia.yaml \
-e $CNF/overcloud-images.yaml \
-e $CNF/service_net_environment.yaml \
-e $CNF/storage-environment.yaml

# -e $CNF/inject-trust-anchor.yaml \
