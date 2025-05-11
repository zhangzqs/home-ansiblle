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

# 禁用systemd-resolved的DNS服务，以便于使用mosdns替代
ansible-playbook playbooks/disable-systemd-resolved.yml -e 'run_hosts=my-j1900'
```
