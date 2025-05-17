#!/bin/sh
set -e

{%- for key, value in service_vars.conf.environments.items() %}
export {{ key }}='{{ value }}'
{%- endfor %}

echo "注册账号：{{ service_vars.conf.email }}"
acme.sh --register-account -m '{{ service_vars.conf.email }}'

echo "申请域名证书：*.{{ home_base_domain }}, DNS供应商：{{ service_vars.conf.dns_provider }}"
acme.sh --issue --dns '{{ service_vars.conf.dns_provider }}' -d '*.{{ home_base_domain }}' --log || true

echo "安装证书：*.{{ home_base_domain }}, 证书路径：/sslcerts/{{ home_base_domain }}.crt, 私钥路径：/sslcerts/{{ home_base_domain }}.key"
acme.sh --install-cert -d '*.{{ home_base_domain }}' \
    --key-file '/sslcerts/{{ home_base_domain }}.key' \
    --fullchain-file '/sslcerts/{{ home_base_domain }}.crt' 
