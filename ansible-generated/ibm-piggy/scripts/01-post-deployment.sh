#!/bin/bash

source ~/overcloudrc

# Create provider networks

openstack \
  network \
  create provider_network \
  --provider-physical-network datacentre \
  --provider-network-type flat \
  --external \
  --share

openstack \
  subnet \
  create \
  provider-subnet \
  --network provider_network \
  --dhcp \
  --allocation-pool start=150.238.9.141,end=150.238.9.143 \
  --gateway 150.238.2.193 \
  --subnet-range 150.238.9.128/26

# Create images
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img -O /home/stack/files/cirros-0.4.0-x86_64-disk.img

openstack \
  image \
  create \
  --disk-format qcow2 \
  --container-format bare \
  --file files/cirros-0.4.0-x86_64-disk.img \
  cirros-0.4.0

openstack \
  flavor \
  create \
  --vcpus 1 \
  --ram 128 \
  m1.micro

openstack \
  flavor \
  create \
  --vcpus 4 \
  --ram 4096 \
  m1.small
