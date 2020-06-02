### r 是Ci/cd工具
```
##查看使用帮助
./r 
```
### 使用方法
1. 配置env参数
2. 运行
```bash
#自定义docker-compose.yml文件,让sonarqube使用H2，还是使用mysql或者pg
#生产环境建议不要使用H2仓库，参数空则默认使用H2
./r i [pg|mysql]或者空
```

### 发布一个精简的版本,不包含数据,在dist目录下

```bash
./r dist
```



### sonarqube docker环境变量
https://docs.sonarqube.org/latest/setup/environment-variables/

### 注意使用docker-desktop或者docker for windows，设置RESOURCES内存 提供6G以上内存
不然sonarqube因为内存不足，会导致出现连接h2 socket timetout

### 编排文件说明
1. docker-compose.mysql.temp.yml sonarqube lts 支持mysql
2. docker-compose.pg.temp.yml sonarqube 8+不支持mysql,只能用postgres
3. docker-compose.temp.yml H2数据库

### ENV 文件配置
env里可以参考注释配置 我编译好的定制版本的放在阿里云的镜像,见env文件说明
registry.cn-hangzhou.aliyuncs.com

### 子文件夹下的Dockerfile用来编译成自定义镜像,以免jenkins/sonarqube使用国外镜像,下载速度慢