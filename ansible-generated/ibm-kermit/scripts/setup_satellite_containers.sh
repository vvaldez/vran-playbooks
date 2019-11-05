export CNF=~/ansible-generated/templates

openstack overcloud container image prepare \
  --namespace=rhosp13 \
  --prefix=openstack- \
  --output-images-file /home/stack/satellite_images \
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

awk -F ':' '{if (NR!=1) {gsub("[[:space:]]", ""); print $2}}' ~/satellite_images > ~/satellite_images_name

hammer product create \
  --organization "GLS" \
  --name "OSP13 Containers"
# Product created.

hammer repository create \
  --organization "GLS" \
  --product "OSP13 Containers" \
  --content-type docker \
  --url https://registry.access.redhat.com \
  --docker-upstream-name rhosp13/openstack-base \
  --name base
# Repository created.


while read IMAGE; do \
  IMAGENAME=$(echo $IMAGE | cut -d"/" -f2 | sed "s/openstack-//g" | sed "s/:.*//g") ; \
  hammer repository create \
  --organization "GLS" \
  --product "OSP13 Containers" \
  --content-type docker \
  --url https://registry.access.redhat.com \
  --docker-upstream-name $IMAGE \
  --name $IMAGENAME ; done < satellite_images_names
# Repository created.
# Repository created.
# Repository created.
# ...

hammer product synchronize \
  --organization "GLS" \
  --name "OSP13 Containers"
