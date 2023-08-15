[简体中文](./README.md) | [English](./README.en.md)

# SolveStack

[![Python 3.9](https://img.shields.io/badge/python-3.9-blue.svg)](https://github.com/weideguo/solvestack) 
[![nodejs](https://img.shields.io/badge/nodejs-blue.svg)](https://github.com/weideguo/solvestack) 
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE) 


Simple command deliver server, base on SSH.  
基于SSH实现的命令分发服务。


start
--------------
### clone ###
```shell
#复制时需要加--recursive参数
git clone --recursive https://github.com/weideguo/solvestack.git
```

### all servers ###
* redis           用于存储数据 可以单独放在一台服务器，与solve最好一一对应。(>=2.0.0)
* [solve](https://github.com/weideguo/solve)          核心命令分发服务 一个隔离的SSH网络（即SSH能连接的网络）需要一个solve服务
* [solve-backend](https://github.com/weideguo/solve-backend)    web后端 由于跟solve有文件关联，需要与solve放在同一台服务器(solve启用文件管理时则不必放在一起，但solve与solve-backend之间必须确保网络安全)
* [solve-frontend](https://github.com/weideguo/solve-frontend)   web前端 可以单独放在一台服务器
* mongodb          持久化存储，可选
* nginx           前后端的代理 生产环境应该使用https防止信息传输时泄露


deploy
--------------

部署架构
```
                                         +------------------+
                                         |                  |
                                         |  solve-frontend  |
                                         |                  |
                                         +--------+---------+
                                                  |
                                   https          |
              +-----------------------------------+-------------------+
              |                                                       |
+------------------------------------------------+             +------+---------+
|             |                                  |             |                |
|     +-------+---------+     +------------+     |             |                |
|     |                 |     |            |     |             |                |
|     |  solve-backend  +-----+   mongodb  |     |             |                |
|     |                 |     | (optional) |     |             |                |
|     +-------+---------+     +------------+     |             |                |
|             |                                  |             |                |
|             |                                  |             |                |
|     +-------+---------+                        |             |                |
|     |                 |                        |             |                |
|     |      redis      |                        |             |                |
|     |                 |                        |             |       IDC 2    |
|     +-------+---------+                        |             |                |
|             |                                  |             |                |
|             |                                  |             |                |
|     +-------+---------+                        |             |                |
|     |                 |                        |             |                |
|     |     solve       |                        |             |                |
|     |                 |                        |             |                |
|     +-----------------+                        |             |                |
|                                                |             |                |
|                       IDC 1                    |             |                |
+------------------------------------------------+             +----------------+

```

docker
--------------
### start ### 
```
cd ${SRC_HOME}
# 设置相关依赖参数，根据注释的信息进行更改，更改完毕删除`#`注释的信息
vim .env
# 构建镜像并启动容器，生成四个镜像并启动四个容器（再次执行不会新创建镜像）
docker-compose up -d

# 启动redis后，进入redis命令设置持久化
CONFIG SET SAVE "900 1 300 10 60 10000"
```

### info ###
http://${CURRENT_IP}:8080    admin/test1234

需要联网从dockerhub的公共仓库（建议使用国内代理）pull三个镜像 redis:4.0  python:3.9  node:16.14
也可以自行在本地现行构建这三个镜像，从而不需要依赖网络下载。 
python/node镜像位提供python/node运行环境即可，即为存在python命令以及node命令。

注意：该部署方式只是用于内网安全环境，请勿对公网开放。生产环境可以考虑对后端服务、前端服务使用nginx实现https代理防止抓包泄露数据。


### more ###
```
#手动构建镜像样例
#solve
#docker build -t solve:latest -f Dockerfile .
docker build -t solve:latest --build-arg INDEX_URL=https://mirrors.aliyun.com/pypi/simple/ --build-arg TRUSTED_HOST=mirrors.aliyun.com  -f Dockerfile .      
#solve-backend
docker build -t solve-backend:latest --build-arg INDEX_URL=https://mirrors.aliyun.com/pypi/simple/ --build-arg TRUSTED_HOST=mirrors.aliyun.com  -f Dockerfile .
#solve-frontend
docker build -t solve-frontend:latest --build-arg REGISTRY=https://registry.npm.taobao.org/  -f Dockerfile .
```

```
#单个容器启动样例
docker run --name solve --env REDIS_HOST=192.168.253.128 -v /tmp:/tmp -d <solve_images_id>

docker run --name solve-backend --env REDIS_HOST=192.168.253.128 -p 8000:8000 -v /tmp:/tmp -d <solve-backend_images_id>

docker run --name solve-frontend --env REDIS_HOST=192.168.253.128 -p 8080:8080 -d <solve-frontend_images_id>

```


usage
--------------

[使用样例](./doc/)


