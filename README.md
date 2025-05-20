# home-ansiblle

自用的家庭网络环境的 Ansible 自动化运维部署脚本

## Ansible 安装

部署需要依赖 ansible, 推荐使用 `uv` 来使用 ansible, 避免使用本机自带的 Python 环境和 Ansible 环境导致的兼容性问题。

通过`env.sh`脚本，可以保证全自动的`uv`环境配置并自动`alias`常用的 ansible 命令。

```bash
source env.sh
# ping 所有机器
ansible all -m ping
```

## 常用 Playbook

```bash
# 初始化一个新节点，完成用户创建，Docker 环境安装
ansible-playbook playbooks/init-node.yml -e 'run_hosts=my-j1900'

# 一键部署运行所有Docker服务
ansible-playbook playbooks/install-all.yml -e 'run_hosts=my-j1900'

# 禁用systemd-resolved的DNS服务，以便于使用mosdns替代
ansible-playbook playbooks/disable-systemd-resolved.yml -e 'run_hosts=my-j1900'

# 单独部署服务
ansible-playbook playbooks/push-service.yml -e 'service=prometheus'

# 自动配置/etc/fstab挂载磁盘
ansible-playbook playbooks/auto-config-fstab.yml -e 'run_hosts=my-j1900' --extra-vars '{
  "mounts": [
    {"device": "/dev/sdb1", "path": "/mnt/disk-inner"},
    {"device": "/dev/sdc1", "path": "/mnt/disk-4t"}
  ]
}'

# 清理所有服务（危险！！！）
ansible-playbook playbooks/reset-all.yml -e 'run_hosts=my-j1900'

# acme.sh 自动化申请一张SSL证书，并保存至 inventory/default/sslcerts 中
ansible-playbook playbooks/issue-ssl.yml -e 'run_hosts=my-j1900'

# 更新nginx服务配置
ansible-playbook playbooks/push-service.yml -e 'service=nginx'
```

## 其他 Playbook

## 服务列表

| 服务名称      | 说明                           | 开放端口   | Nginx 地址               |
| ------------- | ------------------------------ | ---------- | ------------------------ |
| fluentd       | 用于所有服务的日志收集         | 24224      | -                        |
| mosdns        | 用于家庭网络的总 DNS 服务器    | 53         | -                        |
| nginx         | 反向代理，各个服务统一入口服务 | 80, 443    | -                        |
| portainer     | Docker 容器管理服务            | 9000, 9443 | portainer.i.zhangzqs.cn  |
| node_exporter | 主机节点监控服务               | 9100       | -                        |
| cadvisor      | Docker 容器监控服务            | 8080       | -                        |
| prometheus    | 监控服务                       | 9090       | prometheus.i.zhangzqs.cn |
| speedtest     | 测速服务                       | 8082       | speedtest.i.zhangzqs.cn  |
| samba         | 文件共享服务                   | 445        | -                        |
| plantuml      | UML 在线绘图服务               | 8085       | plantuml.i.zhangzqs.cn   |
| gitea         | Git 代码托管服务               | 3001, 222  | gitea.i.zhangzqs.cn      |
| drawio        | 在线绘图服务                   | 8083       | drawio.i.zhangzqs.cn     |
| acme_sh       | SSL 证书申请服务               | -          | -                        |
| aria2 | 下载服务 | 6800, 6801 | aria2.i.zhangzqs.cn |
