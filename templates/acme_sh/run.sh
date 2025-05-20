#!/bin/sh
set -e

{%- for key, value in acme_sh.conf.environments.items() %}
export {{ key }}='{{ value }}'
{%- endfor %}

echo "注册账号：{{ acme_sh.conf.email }}"
acme.sh --register-account -m '{{ acme_sh.conf.email }}'

echo "申请域名证书：*.{{ home_base_domain }}, DNS供应商：{{ acme_sh.conf.dns_provider }}"
acme.sh --issue --dns '{{ acme_sh.conf.dns_provider }}' -d '*.{{ home_base_domain }}' --log || true

echo "安装证书：*.{{ home_base_domain }}, 证书路径：/sslcerts/{{ home_base_domain }}.crt, 私钥路径：/sslcerts/{{ home_base_domain }}.key"
acme.sh --install-cert -d '*.{{ home_base_domain }}' \
    --key-file '/sslcerts/{{ home_base_domain }}.key' \
    --fullchain-file '/sslcerts/{{ home_base_domain }}.crt' 
