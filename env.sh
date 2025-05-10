#!/bin/sh

# 检查 uv 是否已安装
if ! command -v uv &> /dev/null; then
  echo "uv not found, installing..."
  # 下载并安装 uv
  curl -LsSf https://astral.sh/uv/install.sh | sh

  # 检查安装是否成功
  if ! command -v uv &> /dev/null; then
    echo "failed to install uv."
    exit 1
  fi
    echo "uv installed successfully."
else
    echo "uv is already installed."
fi

# 确保 uv 在环境变量中
source $HOME/.local/bin/env

# 尝试执行ansible(第一次运行会自动创建Python虚拟环境)
uv run ansible --version

# alias 一些常用命令
alias ansible="uv run ansible"
alias ansible-playbook="uv run ansible-playbook"