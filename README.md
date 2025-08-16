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
ansible-playbook playbooks/issue-ssl-certs.yml -e 'run_hosts=my-j1900'

# 更新nginx服务配置
ansible-playbook playbooks/push-service.yml -e 'service=nginx'

# 备份所有的docker volumes
ansible-playbook playbooks/backup-volumes.yml -e 'src_host=my-j1900 dest_host=my-j1900 dest=/mnt/disk-4t/备份/NAS数据备份/volumes_backup'
```

## 其他 Playbook

```bash
# 拉取所有镜像到本地文件
ansible-playbook ci-playbooks/pull-images.yml --ask-become-pass

# 保存所有镜像到本地文件
ansible-playbook ci-playbooks/save-images.yml --ask-become-pass

# 增量上传镜像到远程s3服务器
ansible-playbook ci-playbooks/upload-images-to-s3.yml --ask-become-pass
```

## 服务列表

| 服务名称         | 说明                                                              | 开放端口   | Nginx 地址                |
| ---------------- | ----------------------------------------------------------------- | ---------- | ------------------------- |
| fluentd          | 用于所有服务的日志收集                                            | 24224      | -                         |
| mosdns           | 用于家庭网络的总 DNS 服务器                                       | 53         | -                         |
| node_exporter    | 主机节点监控服务                                                  | 9100       | -                         |
| cadvisor         | Docker 容器监控服务                                               | 8080       | -                         |
| prometheus       | 监控服务                                                          | 9090       | prometheus.i.zhangzqs.cn  |
| gitea            | Git 代码托管服务                                                  | 3001, 222  | gitea.i.zhangzqs.cn       |
| grafana          | 可视化监控服务                                                    | 3000       | grafana.i.zhangzqs.cn     |
| vaultwarden      | 密码管理服务                                                      | 8081       | vaultwarden.i.zhangzqs.cn |
| portainer        | Docker 容器管理服务                                               | 9000, 9443 | portainer.i.zhangzqs.cn   |
| nginx            | 反向代理，各个服务统一入口服务                                    | 80, 443    | -                         |
| speedtest        | 测速服务                                                          | 8082       | speedtest.i.zhangzqs.cn   |
| drawio           | 在线绘图服务                                                      | 8083       | drawio.i.zhangzqs.cn      |
| samba            | 文件共享服务                                                      | 445        | -                         |
| aria2            | 下载服务                                                          | 6800       | aria2.i.zhangzqs.cn       |
| aria2_ng         | Aria2 Web UI 服务                                                 | 6801       | aria2-ng.i.zhangzqs.cn    |
| acme_sh          | SSL 证书申请服务                                                  | -          | -                         |
| immich           | 图片管理服务                                                      | 8084       | immich.i.zhangzqs.cn      |
| plantuml         | UML 在线绘图服务                                                  | 8085       | plantuml.i.zhangzqs.cn    |
| filebrowser      | 文件浏览服务                                                      | 8086       | filebrowser.i.zhangzqs.cn |
| gitea            | Git 代码托管服务                                                  | 3001, 222  | gitea.i.zhangzqs.cn       |
| kms              | KMS 服务                                                          | 8087, 8088 | kms.i.zhangzqs.cn         |
| dify             | -                                                                 | 8090       | dify.i.zhangzqs.cn        |
| tailscale        | 异地组网                                                          | -          | -                         |
| process_exporter | 进程监控服务                                                      | 9256       | -                         |
| my_exporter      | [我的一些监控指标收集器](https://github.com/zhangzqs/my-exporter) | 8092       | -                         |
| dlna_render      | DLNA 远程播放服务                                                 | -          | -                         |
| it_tools         | 站长工具                                                          | 8096       | it-tools.i.zhangzqs.cn    |
