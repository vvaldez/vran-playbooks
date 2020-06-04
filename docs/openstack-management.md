# OpenStack Management

## Subscribe overcloud node to RHSM

We can run the following playbook against a full overcloud environment, or `limit` to individual hosts:

```sh
ansible-playbook -i ../ansible-inventory/ibm/hosts/osp-fozzie --limit compute16.fozzie.dal10.ole.redhat.com playbooks/operational/openstack-overcloud-rhsm.yml
```
