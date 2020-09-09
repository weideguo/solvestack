Simple command deliver server, base on SSH.   
基于SSH实现的命令分发服务。    
完整部署与使用    

start
--------------
### clone ###
```shell
#复制时需要加--recursive参数
git clone --recursive https://github.com/zouzhicun/solve-stack.git
```

### all servers ###
* redis           用于存储数据 可以单独放在一台服务器，与solve最好一一对应。(>=2.0.0)
* [solve](https://github.com/zouzhicun/solve)          核心命令分发服务 一个隔离的SSH网络（即SSH能连接的网络）需要一个solve服务
* [solve-backend](https://github.com/zouzhicun/solve-backend)    web后端 由于跟solve有文件关联，需要与solve放在同一台服务器(solve启用文件管理时则不必放在一起，但solve与solve-backend之间必须确保网络安全)
* [solve-frontend](https://github.com/zouzhicun/solve-frontend)   web前端 可以单独放在一台服务器
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

usage
--------------

[使用样例](./doc/)


