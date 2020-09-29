#!/usr/bin/env bash

source ~/stackrc

{% for site in sites %}
# {{ site.name_lower }}
{%   for role in site.roles %}
role="{{ role.type.name_lower }}-{{ site.name_lower }}"
openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 ${role}
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="${role}" --property "resources:CUSTOM_BAREMETAL"="1" --property "resources:DISK_GB"="0" --property "resources:MEMORY_MB"="0" --property "resources:VCPU"="0" ${role}
{%   endfor %}

{% endfor %}
