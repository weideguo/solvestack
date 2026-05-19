# solve服务运行架构  

## 部署架构  
本地执行在多master或者多proxy，需要设置local_ip_list不同防止本地执行混乱。    
master/proxy服务之间的文件同步需要额外实现。（如：1.使用rsync；2.启用fileserver，并在上传文件时同时上传所有服务；3.其他自行实现的同步策略）  

* 单master模式  
  最简单模式，所有任务管理以及、主机连接只由一个master服务管理。  

* 单master-多proxy模式  
  master用于任务管理，一个proxy对应一个独立的SSH网络。  
  master/proxy需要连接相同的redis，可以使用vpn实现处于相同内网环境。  
  
* 单master-多相同proxy模式  
  与单master-多proxy模式类似，但一个独立网络部署多个proxy（proxy主要用于主机连接，可以避免主机过多时对proxy压力过大，以及提供高可用）。  
  相同proxy由相同的proxy_mark标记。    
   
* 多master-多相同proxy模式    
  与单master-多相同proxy模式类似，但同时启动多个master（避免master压力过大，以及提供高可用）。    
  
* 多master模式    
  与多master-多相同proxy模式类似，但没有proxy用于连接主机，仅由master处理。       


## proxy模式  
proxy模式用于作为master的代理管理主机连接。整体任务协调均由master发起。 
适用于多机房模式，一个机房使用一个proxy；或者使用多个proxy减少master发起大量ssh连接的压力。  

* proxy启动方式:  
  1.命令行中 python bin/solve.py proxy  
  2.修改配置文件conf/config.py的PROXY，即设置conf/config.conf的proxy模块
* proxy与master的通信通过redis实现  
* 默认启动的模式为master模式，不需要与其他节点有关联  
* 主机通过proxy字段设置使用的代理，格式如 realhost_192.168.16.1 ip 192.168.16.1 proxy aaa ...
* proxy与master文件的同步尚未实现，需要额外的文件同步之后（如使用rsync），才能对proxy管理的主机执行文件上传操作  

## fileserver  
提供简单的文件管理restful接口，可以实现文件上传、下载、文件查看、目录创建，文件内容查看。  
当solve与web服务处于不同主机时，可以启用fileserver以实现文件的管理。  
conf/config的fileserver参数控制是否启用。  
不带权限验证，启用时请务必确保网络安全。（如：1.只监听本地地址/内网地址；2.防火墙+nginx+https）  

## 本地执行  
修改配置文件conf/config.py的local_ip_list，发往该ip列表的地址将不会使用ssh模式运行，而是直接在本地运行。  
对于proxy模式，需要设置local_ip_list与master不相同，防止与master发生冲突。  
命令缓存于队列如：cmd_127.0.0.1 cmd_127.0.0.1_xxx


