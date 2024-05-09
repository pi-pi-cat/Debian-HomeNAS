# 基于Debian搭建HomeNAS
![最终成果展示](https://github.com/kekylin/Debian-HomeNAS/assets/65521882/680df62e-7f6a-4b10-89a5-56cb363eecc8)
这是《基于Debian搭建HomeNAS》教程所写的半自动化配置脚本，目前脚本已经实现教程中以下章节操作。
# 脚本已实现功能
### 一、系统安装  
1.1 系统镜像下载  
1.2 安装教程  
### 二、系统初始化  
2.1 安装初始必备软件 （已实现）  
2.2 添加用户至sudo组 （已实现）  
2.3 更换国内镜像源 （已实现）  
2.4 更新系统 （已实现）  
### 三、安装Cockpit Web管理面板 （已实现）  
3.1 安装Cockpit （已实现）  
3.2 安装Cockpit附属组件 （已实现）  
3.3 Cockpit调优  
### 四、系统调优  
4.1 设置Cockpit接管网络配置 （已实现）  
4.2 调整系统时区/时间  
4.3 交换空间优化  
4.4 安装Tuned系统调优工具 （已实现）  
4.5 新用户默认加入user组  
4.6 修改homes目录默认路径  
4.7 修改用户home目录默认权限  
4.8 创建新用户  
4.9 创建容器专属账户  
4.10 配置邮件发送服务 （已实现）  
4.11 添加Github Hosts  
4.12 添加TMDB Hosts  
4.13 WireGuard家庭组网  
### 五、安全防护  
5.1 配置高强度密码策略  
5.2 用户连续登陆失败锁定  
5.3 禁止root用户密码登陆  
5.4 限制指定用户外网登陆  
5.5 限制指定用户夜间登陆  
5.7 限制用户同时登陆数量  
5.6 限制用户SU （已实现）  
5.8 用户登陆邮件通知告警 （已实现）  
5.9 超时自动注销活动状态 （已实现）  
5.10 记录所有用户的登录和操作日志 （已实现）  
5.11 禁止SSH服务开机自启动  
5.11 安装防火墙  
5.12 安装自动封锁软件  
5.14 安装病毒防护软件  
### 六、存储管理  
6.1 硬盘管理  
6.2 软Raid管理  
6.3 硬盘自动休眠  
6.4 硬盘健康监测  
6.5 安装联合文件系统  
6.5 安装SnapRaid  
### 七、Docker服务  
7.1 Docker安装 （已实现）  
7.2 容器管理 （已实现）  
7.2 反向代理  
7.3 数据库  
7.4 文件存储  
7.5 影音服务  
7.6 下载服务  
7.7 照片管理  
7.8 Blog管理  
7.9 薅羊毛  
### 八、UPS不断电系统  

# 使用方法
### 1、使用SSH连接系统，切换root账户
  ```shell
su -
  ```
### 2、执行脚本下载命令并自动运行
  ```shell
wget -O debian-homenas.sh -q --show-progress https://mirror.ghproxy.com/https://raw.githubusercontent.com/kekylin/debian-homenas/main/debian-homenas.sh && bash debian-homenas.sh
  ```
# 转载请保留出处
- DIY NAS_3群 339169752
