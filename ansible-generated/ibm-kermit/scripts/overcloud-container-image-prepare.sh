export CNF=~/ansible-generated/templates

openstack overcloud container image prepare \
  --namespace=satellite.dal10.ole.redhat.com:5000 \
  --prefix=gls-library-rhosp13-osp13_containers- \
  --tag-from-label {version}-{release} \
  --output-env-file=/home/stack/templates/overcloud_images.yaml \
  -r $CNF/roles_data.yaml \
  -e $CNF/network-config.yaml \
  -e $CNF/environments/network-isolation.yaml \
  -e $CNF/environments/network-environment.yaml \
  -e $CNF/overcloud-images.yaml \
  -e $CNF/node-config.yaml \
  -e $CNF/storage-environment.yaml \
  -e $CNF/inject-trust-anchor.yaml \
  -e $CNF/ips-from-pool-all.yaml \
  -e $CNF/octavia.yaml \
  -e $CNF/service_net_environment.yaml
