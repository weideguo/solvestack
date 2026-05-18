# 全新安装  

## 安装
``` shell
cd ${SRC_HOME}
# 使用样例数据库，否则后端需要先初始化才能启动
cp solve-backend/db.sqlite3.demo docker/solve-backend/db.sqlite3
# 设置相关依赖参数，根据注释的信息进行更改，更改完毕删除`#`注释的信息，不能存在多余空格
vim .env
# 构建镜像并启动容器，生成四个镜像并启动四个容器（再次执行不会新创建镜像）
docker-compose up -d

# 启动redis后，进入redis命令设置持久化
CONFIG SET SAVE "900 1 300 10 60 10000"

# 进入solve容器，手动安装以下依赖
apt update && apt install -y sshpass pv curl wget
```

## 登录信息  
http://&#36;{CURRENT_IP}:8080   
默认账号密码 admin/test1234  

## docker镜像  
需要联网从dockerhub的公共仓库（建议使用国内代理）pull基础镜像 
```  
redis:4.0  
python:3.13.13-slim-bookworm  
nginx:alpine  # docker tag nginx:1.29.8-alpine nginx:alpine
node:24       # docker tag node:24.15.0-alpine3.22 node:24   # 仅前端编译需要
```
也可以自行在本地现行构建这三个镜像，从而不需要依赖网络下载。 

## 注意  
> 该部署方式只是用于内网安全环境，请勿对公网开放。
> 生产环境可以考虑对后端服务、前端服务使用nginx实现https代理防止抓包泄露数据。
