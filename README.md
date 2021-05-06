Simple command deliver server, base on SSH.   
基于SSH实现的命令分发服务。    
完整部署与使用    

start
--------------
### clone ###
```shell
#复制时需要加--recursive参数
git clone --recursive https://github.com/weideguo/solve-stack.git
```

### all servers ###
* redis           用于存储数据 可以单独放在一台服务器，与solve最好一一对应。(>=2.0.0)
* [solve](https://github.com/weideguo/solve)          核心命令分发服务 一个隔离的SSH网络（即SSH能连接的网络）需要一个solve服务
* [solve-backend](https://github.com/weideguo/solve-backend)    web后端 由于跟solve有文件关联，需要与solve放在同一台服务器(solve启用文件管理时则不必放在一起，但solve与solve-backend之间必须确保网络安全)
* [solve-frontend](https://github.com/weideguo/solve-frontend)   web前端 可以单独放在一台服务器
* mongodb          持久化存储，可选
* nginx           前后端的代理 生产环境应该使用https防止信息传输时泄露


depoly
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
#复制共享的文件到共享目录 
#如果新创建的playbook，请都存放于共享目录以便各个组件能通过绝对路径访问
#容器间共享目录的设置详细见docker-compose.yml中volumes
cp -r solve/playbook /tmp/

#获取当前主机的ip，即为前后端通信使用的ip
CURRENT_IP=`ip addr | grep inet |grep -v inet6 | awk '{print $2}' | awk -F "/" '{print $1}' | grep -E "(^192\.|^172\.|^10\.)"`
#请务必先确认ip是否正确
echo $CURRENT_IP

sed -i "s|127.0.0.1|${CURRENT_IP}|g"  docker-compose.yml

#根据实际情况可能要修改以下文件 修改对应的源
#solve/Dockerfile
#solve-backend/Dockerfile
#solve-frontend/Dockerfile 

#构建镜像并启动容器，生成四个镜像并启动四个容器（再次执行不会新创建镜像）
docker-compose up -d
```

### info ###
http://${CURRENT_IP}:8080    admin/test1234

需要联网从dockerhub的公共仓库（建议使用国内代理）pull三个镜像 redis:4.0  python:3.5  node:10.13
也可以自行在本地现行构建这三个镜像，从而不需要依赖网络下载。 
python/node镜像位提供python/node运行环境即可，即为存在python命令以及node命令。

注意：该部署方式只是用于测试，存在安全风险，请勿使用于生产环境。


### more ###
```
#手动构建镜像样例
docker build -t solve:latest -f Dockerfile .
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


