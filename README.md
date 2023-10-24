# 学习Linux的Shell脚本命令
> 运行环境：
> - CentOS  7.7
# 运行步骤
## 拉取脚本文件
```shell
wget -N -P ~ https://raw.githubusercontent.com/Aixuxuxu/linux-shell-learn/main/install_docker.sh
```
## 赋予脚本执行权限
```shell
 chmod +x install_docker.sh
```
## 执行脚本
执行脚本的方法有两种，分别是`相对路径`和`绝对路径`，二者选其一即可，如下：
### 相对路径
```shell
./install_docker.sh
```
### 绝对路径
```shell
~/install_docker.sh
```