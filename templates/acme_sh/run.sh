#!/bin/sh

{%- for key, value in service_vars.conf.environments.items() %}
export {{ key }}='{{ value }}'
{%- endfor %}

acme.sh --register-account -m '{{ service_vars.conf.email }}'
acme.sh --issue --dns '{{ service_vars.conf.dns_provider }}' -d '*.{{ home_base_domain }}'    
acme.sh --install-cert -d '*.{{ home_base_domain }}' \
    --key-file '/sslcerts/{{ home_base_domain }}.key' \
    --fullchain-file '/sslcerts/{{ home_base_domain }}.crt' 