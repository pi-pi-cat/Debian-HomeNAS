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

echo "欢迎使用Debian镜像源设置脚本!"
echo "正在检测您的网络环境..."

# 检测是否能访问谷歌（判断是否在中国境内）
if ping -c 1 -W 1 google.com > /dev/null 2>&1; then
    IN_CHINA=false
    echo "检测到您的网络可以访问Google，将使用官方源。"
else
    IN_CHINA=true
    echo "检测到您可能处于中国网络环境，将使用国内镜像源。"
fi

# 询问用户是否确认继续
read -p "是否继续设置镜像源？(y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "设置已取消。"
    exit 1
fi

echo "开始设置镜像源..."

# 备份和清理源文件
echo "备份并清理现有的源文件..."
cp /etc/apt/sources.list /etc/apt/sources.list.original.bak
find /etc/apt/sources.list.d/ -type f -name '*.list' -exec cp {} {}.bak \;
rm /etc/apt/sources.list
rm /etc/apt/sources.list.d/*.list

# 禁用或删除镜像列表文件
echo "禁用镜像列表文件..."
if [ -d "/etc/apt/mirrors" ]; then
    mv /etc/apt/mirrors /etc/apt/mirrors.bak
fi
rm -f /etc/apt/mirrorlist.html /etc/apt/mirror-dist.sh

# 创建新的源文件
if $IN_CHINA; then
    echo "使用清华大学镜像源..."
    cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
else
    echo "使用Debian官方源..."
    cat > /etc/apt/sources.list << EOF
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
fi

# 确保 apt 不会使用任何镜像列表
echo 'Acquire::DisableMoveMirrors "true";' > /etc/apt/apt.conf.d/99disable-move-mirrors

echo "更新软件包列表..."
apt-get update

echo "Debian镜像源设置完成。"
