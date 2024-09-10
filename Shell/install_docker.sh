#!/bin/bash

# 检查是否以root用户运行
if [[ $EUID -ne 0 ]]; then
   echo "错误: 请使用root权限运行该脚本。" 
   exit 1
fi

# 检测系统是否为Debian
if [[ ! -f /etc/debian_version ]]; then
    echo "错误: 此脚本仅适用于Debian系统。"
    exit 1
fi

echo "欢迎使用Docker安装脚本!"
echo "正在检测您的网络环境..."

# 检测是否能访问谷歌（判断是否在中国境内）
if ping -c 1 -W 1 google.com > /dev/null 2>&1; then
    IN_CHINA=false
    echo "检测到您的网络可以访问Google，将使用官方Docker源。"
else
    IN_CHINA=true
    echo "检测到您可能处于中国网络环境，将使用国内Docker镜像源。"
fi

# 询问用户是否确认继续
read -p "是否继续安装Docker？(y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "安装已取消。"
    exit 1
fi

echo "开始安装Docker..."

echo "安装必要的依赖包..."
apt-get update
apt-get install -y ca-certificates curl gnupg

echo "创建 Docker GPG密钥目录..."
install -m 0755 -d /etc/apt/keyrings

# 选择Docker镜像源
if $IN_CHINA; then
    DOCKER_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
    echo "将使用清华大学Docker镜像源"
else
    DOCKER_MIRROR="https://download.docker.com"
    echo "将使用Docker官方镜像源"
fi

echo "添加 Docker 的官方 GPG 密钥..."
if ! curl -fsSL $DOCKER_MIRROR/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; then
    echo "错误: 无法添加Docker GPG密钥。请检查您的网络连接。"
    exit 1
fi

echo "设置 GPG 密钥权限..."
chmod a+r /etc/apt/keyrings/docker.gpg

echo "添加 Docker 软件源..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $DOCKER_MIRROR/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "更新软件包列表..."
apt-get update

echo "安装 Docker..."
if ! apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
    echo "错误: Docker安装失败。请检查上述错误信息并重试。"
    exit 1
fi

echo "启动 Docker 服务..."
systemctl start docker

echo "检查 Docker 是否成功启动..."
if ! systemctl is-active --quiet docker; then
    echo "警告: Docker未能成功启动。请检查系统日志以获取更多信息。"
else
    echo "Docker 已成功启动。"
fi

echo "设置 Docker 开机自启动..."
systemctl enable docker

# 提示用户输入要添加到docker组的用户名
echo "为了避免每次使用docker命令都需要sudo，您可以将用户添加到docker组。"
read -p "请输入要添加到 docker 组的用户名（如不需要，直接按回车跳过）: " username

if [ -n "$username" ]; then
    if id "$username" &>/dev/null; then
        usermod -aG docker "$username"
        echo "用户 $username 已被添加到 docker 组。"
        echo "请注销并重新登录以使组成员身份生效。"
    else
        echo "警告: 用户 $username 不存在。请检查用户名并手动添加到 docker 组。"
    fi
else
    echo "跳过添加用户到 docker 组。"
fi

echo "Docker 安装完成。"
echo "您可以通过运行 'docker --version' 来验证安装。"
echo "如果您刚才添加了用户到 docker 组，请记得注销并重新登录以使更改生效。"
