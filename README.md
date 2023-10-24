# 学习Linux的Shell脚本命令
> 这个脚本能干什么？这个问题是我在写这个脚本的时候一直在思考的问题，我想到的答案是：这个脚本能够帮助我学习Linux的Shell脚本命令
> ，同时也能够帮助我快速的搭建一些常用的服务，比如：docker、nginx、mysql、redis等等。既然是学习，那么就要有学习的过程，所以
> 我会在脚本中加入一些注释，这些注释是我在学习的过程中，对于某个命令的理解，如果有错误的地方，欢迎指正。
> 
> 运行环境：
> - CentOS  7.7
 （理论上CentOS7应该都能够运行）
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