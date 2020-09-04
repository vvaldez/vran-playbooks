#!/usr/bin/env bash

set -x

source /home/stack/stackrc

{% for site in sites %}
{%   set loop_index = loop.index0 %}
# {{ site.name_lower }}
{%   for role in site.roles %}
{%     for n in range(role.count) %}
{%       set name="%s-%s-%s"|format(role.type.name_lower, site.name_lower, n + 1) %}
PORT=$(openstack baremetal port list --node {{ name }} -f value -c UUID)
{%       if loop_index == 0 %}
openstack baremetal port set --physical-network ctlplane $PORT
{%       else %}
openstack baremetal port set --physical-network {{ site.name_lower }} $PORT
{%       endif %}
{%     endfor %}
{%   endfor %}

{% endfor %}
