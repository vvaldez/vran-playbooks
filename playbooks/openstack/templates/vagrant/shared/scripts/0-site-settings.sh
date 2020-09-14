

export satellite={{ undercloud.rhsm_server_hostname }}
export org={{ undercloud.rhsm_org_id }}
export director_activation_key='{{ undercloud.rhsm_activationkey }}'
export realtime_activation_key='{{ undercloud.rhsm_realtime_activation_key }}'

export hostname='{{ undercloud.hostname.split('.')[0] }}'
export ip_address='{{ hostvars['director.escwq.xyz']['ansible_host'] }}'
export domain='{{ undercloud.hostname.split('.')[1:] | join('.') }}'
export stack_password='redhat'
export osp_version='16.1'
export template_path='~/ansible-generated/templates'

export stack_name='vranlab'

home=~
rcfile=$home/$stack_name
rcfile+="rc"
export rcfile
