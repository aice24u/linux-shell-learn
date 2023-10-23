#!/bin/bash

# 更新系统
sudo yum update -y

# 企业版 Linux 额外包
yum install -y epel-release

# 安装依赖包
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 设置 Docker 的 yum 源
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 安装 Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io

# 启动 Docker 服务
sudo systemctl start docker

# 设置 Docker 开机自启
sudo systemctl enable docker

# 验证 Docker 安装是否成功
sudo docker run hello-world

# 安装 MySQL 5.7 镜像
echo "正在拉取 MySQL 镜像..."
sudo docker pull mysql:5.7 

# 安装 Nginx 1.20.2 镜像
echo "正在拉取 Nginx 镜像..."
sudo docker pull nginx:1.20.2 

# 安装 Minio 镜像
echo "正在拉取 Minio 镜像..."
sudo docker pull minio/minio 

# 安装 Redis 6.0.20 镜像
echo "正在拉取 Redis 镜像..."
sudo docker pull redis:6.0.20 

# 安装 Git
sudo yum install -y git

# 创建docker文件夹
mkdir -p ~/docker

# 创建mysql、nginx、redis和minio文件夹
mkdir -p ~/docker/mysql
mkdir -p ~/docker/nginx
mkdir -p ~/docker/redis
mkdir -p ~/docker/minio

# 创建nginx映射目录
mkdir -p ~/docker/nginx/conf
mkdir -p ~/docker/nginx/html
mkdir -p ~/docker/nginx/logs

chmod -R 777 ~/docker

# 获取版本信息
docker_version=$(sudo docker version --format '{{.Server.Version}}')
mysql_version=$(sudo docker run --rm mysql:5.7 mysql --version | awk '{print $5}')
nginx_version=$(sudo docker run --rm nginx:1.20.2 nginx -v 2>&1 | awk -F '/' '{print $2}')
minio_version=$(sudo docker run --rm minio/minio minio version | awk '{print $3}')
redis_version=$(sudo docker run --rm redis:6.0.20 redis-server --version | awk '{print $3}')
git_version=$(git --version | awk '{print $3}') 

# 获取Nginx镜像ID
nginx_image_id=$(docker images --format "{{.ID}}" --filter "reference=nginx:1.20.2")

# 输出Nginx镜像ID
echo "Nginx镜像ID: $nginx_image_id"

# 下载配置文件
wget -N -P ~/docker/nginx/html https://raw.githubusercontent.com/Aixuxuxu/linux-shell-learn/main/docker/nginx/index.html
wget -N -P ~/docker/nginx https://raw.githubusercontent.com/Aixuxuxu/linux-shell-learn/main/docker/nginx/nginx.conf

# docker部署nginx
docker run -d --restart=on-failure:5 --name nginx -p 80:80 -v ~/docker/nginx/nginx.conf:/etc/nginx/nginx.conf -v ~/docker/nginx/logs:/var/log/nginx -v ~/docker/nginx/html:/usr/share/nginx/html -v ~/docker/nginx/conf:/etc/nginx/conf.d --privileged=true "$nginx_image_id"

# 输出docker镜像列表
sudo docker images

# 格式化输出版本信息
echo "安装版本信息："
printf "%-12s %s\n" "Docker:" "$docker_version"
printf "%-12s %s\n" "Git:" "$git_version"