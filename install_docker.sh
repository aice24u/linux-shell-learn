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

# 安装 MySQL 5.7 镜像
echo "正在拉取 MySQL 镜像..."
sudo docker pull mysql:5.7

# 安装 Nginx 1.20.2 镜像
echo "正在拉取 Nginx 镜像..."
sudo docker pull nginx:1.20.2

# 安装 Minio 镜像
echo "正在拉取 Minio 镜像..."
#sudo docker pull minio/minio
docker pull minio/minio:RELEASE.2021-06-17T00-10-46Z

# 拉取 Redis 6.0.20 镜像
echo "正在拉取 Redis 镜像..."
sudo docker pull redis:6.0.20

# 拉取 RabbitMQ 3.8.34管理端经 镜像
echo "正在拉取 Rabbit 镜像..."
sudo docker pull rabbitmq:3.8.34-management

# 安装 Git
sudo yum install -y git

##################### 创建映射目录 ###################

# 创建docker文件夹
mkdir -p ~/docker

# 创建mysql、nginx、redis和minio文件夹
mkdir -p ~/docker/{mysql,nginx,redis,minio,rabbitmq}

# 创建nginx,mysql,redis,minio映射目录
mkdir -p ~/docker/nginx/{conf,html,logs}
mkdir -p ~/docker/mysql/{conf,data,logs}
mkdir -p ~/docker/minio/{config,data}
mkdir -p ~/docker/redis/{conf,data}
mkdir -p ~/docker/rabbitmq/conf

# 创建mysql的conf
touch ~/docker/mysql/conf/my.cnf

chmod -R 777 ~/docker

###################### 部署docker镜像 ###################
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
wget -N -P ~/docker/redis/conf https://raw.githubusercontent.com/Aixuxuxu/linux-shell-learn/main/docker/redis/redis.conf
wget -N -P ~/docker/rabbitmq/conf https://raw.githubusercontent.com/Aixuxuxu/linux-shell-learn/main/docker/rabbitmq/rabbitmq.conf

# docker部署nginx
docker run -d --restart=on-failure:5 --name nginx -p 80:80 -v ~/docker/nginx/nginx.conf:/etc/nginx/nginx.conf -v ~/docker/nginx/logs:/var/log/nginx -v ~/docker/nginx/html:/usr/share/nginx/html -v ~/docker/nginx/conf:/etc/nginx/conf.d --privileged=true "$nginx_image_id"

# docker 部署minio
docker run -d -p 9000:9000 --name minio\
  -e "MINIO_ACCESS_KEY=aixu" \
  -e "MINIO_SECRET_KEY=Xu1876414429..." \
  -v ~/docker/minio/data:/data \
  -v ~/docker/minio/config:/root/.minio \
  minio/minio:RELEASE.2021-06-17T00-10-46Z server /data

# docker 部署mysql ---> 6630端口
docker run -p 6630:3306 --name mysql \
-v ~/docker/mysql/conf:/etc/mysql/conf.d \
-v ~/docker/mysql/logs:/logs \
-v ~/docker/mysql/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=Xu1876414429... -d mysql:5.7

# docker 部署redis ---> 6399端口
docker run -d --privileged=true -p 6399:6379 --restart always -v /root/docker/redis/conf/redis.conf:/etc/redis/redis.conf -v /root/docker/redis/data:/data --name redis redis:6.0.20 redis-server /etc/redis/redis.conf --appendonly yes

# docker 部署rebitmq
docker run -d -p 5672:5672 -p 15672:15672 --name rabbitmq -v ~/docker/rabbitmq/conf/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf rabbitmq:3.8.34-management


######################### 进入容器中操作 ##############

# SQL命令
sleep 10

# SQL命令
SQL_COMMANDS="use mysql;
CREATE USER 'aixu'@'%' IDENTIFIED BY 'Xu1876414429...';
GRANT ALL PRIVILEGES ON *.* TO 'aixu'@'%';
FLUSH PRIVILEGES;
UPDATE user SET host='%' WHERE user='aixu';
FLUSH PRIVILEGES;"

# 将SQL命令传递给MySQL客户端
echo "$SQL_COMMANDS" | docker exec -i mysql mysql -uroot -pXu1876414429...

# 检查命令是否成功执行
if [ $? -eq 0 ]; then
    echo "SQL命令执行成功！"
else
    echo "SQL命令执行失败。"
fi


######################### 输出信息 ################
# 输出docker镜像列表
sudo docker images

# 格式化输出版本信息
echo "安装版本信息："
printf "%-12s %s\n" "Docker:" "$docker_version"
printf "%-12s %s\n" "Git:" "$git_version"