# 底层执行     

使用命令行使用solve，可以不依赖web前端、web后端。  

redis_send redis_log redis_job redis_config为配置文件conf/config.py中设置的redis，即conf/config.conf对应的模块

更多playbook与使用样例详见[playbook示例目录](https://github.com/weideguo/solve/blob/master/playbook/simple)

## playbook命令样例  
```shell
#跳转语句 左右只允许存在空格
[10.0.0.1]
[{{ip}}]
#全局参数
global.my_global_test=`date +%s`abc
#使用全局参数
echo {{global.my_global_test}}
#使用session参数 session参数值在创建job时设置
echo {{session.my_session_test}}
#单行命令
mysql -u{{const.db_user}} -p{{const.db_passwd}} -h127.0.0.1 -P{{db_port}} -e"show databases"
#上传文件 远端目录不存在则创建 文件名跟本地一样 
#通过md5判断是否一致 远端文件存但md5不一样则被重命名（加时间戳后缀）
__put__ /tmp/my_local_file /tmp
__put__ {{session.local_file}} {{session.remote_path}}
#上传也可以后台运行
__put__ {{session.local_file}} {{session.remote_path}} &
#下载文件 本地目录不存在则创建 文件名跟远端的一样 本地文件存在则被重命名（加时间戳后缀）
__get__ /tmp/my_remote_file /tmp
__get__ {{session.remote_file}} {{session.local_path}} 
#下载也可以后台运行
__get__ {{session.remote_file}} {{session.local_path}} &
#后台运行 &之后只允许存在空格
#可以跨多个主机后台运行，即发生主机跳转也可以
echo "111" ; sleep 15 &
echo "222" && sleep 13 &
echo "333" && sleep 14 &
#等待所有后台运行的结束 左右只允许存在空格
wait
#分发的命令需要后台运行时，则需要在尾部多加一个&
#一个&为命令分发系统使用，另外一个&为实际执行时使用
#这种返回之只是一个虚构的值，需要再次确认是否运行正确，如检查进程是否存在，因而其他命令不应该依赖该命令的执行结果。
cd /data/redis && bin/redis-server redis.conf & &
```
## 创建job
```
# 创建playbook
cat > /tmp/myplaybook.txt <<EOF
[{{ip}}]
echo {{ip}}
echo {{port}}
EOF

#以下操作要在redis操作
#创建连接主机 名字必须为 realhost_<ip> 格式固定
redis_config> hmset realhost_10.0.0.1 ip 10.0.0.1 user root ssh_port 22 passwd my_ssh_passwd
#默认使用运行该程序用户的ssh目录即 ~/.ssh 进行免密认证。如文件 ~/.ssh/id_rsa。如果预先进行免密登陆设置，则passwd的值设置与否或者是否正确无关紧要，优先使用免密设置。
#同时也支持ssh-agent加载其他位置的私钥文件，先加载后启动该程序
#realhost_<ip> 的passwd 可以为加密后的字符串
#python script/solve_password.py 'my_ssh_passwd'   #由原始密码生产加密字符串
#python script/solve_password.py -d '$aes_password$KzZPM01rO2wtLkcwelt6KA==$ILeCn13IoiPjE6OwpZSxLA=='  #解密验证
redis_config> hmset realhost_10.0.0.1 ip 10.0.0.1 user root ssh_port 22 passwd '$aes_password$KzZPM01rO2wtLkcwelt6KA==$ILeCn13IoiPjE6OwpZSxLA=='
#设置执行对象
redis_config> hmset server_mysql_10.0.0.1 ip 10.0.0.1 port 3306
#设置session参数 要设置的属性由playbook使用的session参数确定
redis_tmp> hmset session_dcf3e208d47011e99464000c295dd589 "my_session_test" "bbbbb" "local_file" "/tmp/abc.txt"
#创建job
redis_job> hmset job_dcf3e208d47011e99464000c295dd589 "target" "server_mysql_10.0.0.1" "playbook" "/tmp/myplaybook.txt" "session" "session_dcf3e208d47011e99464000c295dd589"
#执行job
redis_send> rpush job_list job_dcf3e208d47011e99464000c295dd589
#查看执行结果
redis_log> hgetall log_job_dcf3e208d47011e99464000c295dd589
```

## 通过脚本模式运行
```shell
#根据提示输入 target、playbook以及需要设置的session参数
python script/solve_exe.py
```

## 高级用法  
```
#对指定执行对象终止操作
#kill_<cluster id>;由 log_job_<job id>中确定
redis_send> set kill_<cluster id> 1
#设置cluster执行一条命令后阻塞，再次插入0则继续执行一条命令后阻塞
redis_send> rpush block_<cluster id> 0
#结束阻塞，剩下的命令按正常顺序全部执行
redis_send> rpush block_<cluster id> -1
#阻塞超时，剩下的命令全部不执行，不需要手动操作，通过redis的blpop实现超时
redis_send> rpush block_<cluster id> "pause timeout"
#其他值则可以结束阻塞并终止之后的所有操作
redis_send> rpush block_<cluster id> abort
#主机连接的建立与关闭
redis_send> rpush conn_control "10.0.0.1" "close_10.0.0.1" "10.0.0.1@@@@63d07bf6f49c11e9befb000c295dd589"
#重新执行
#可以由原有的job重新构建，并设置begin_line,实现断点继续运行。
#直接对主机分发命令 必须先连接主机
redis_send> rpsuh cmd_10.0.0.1 "whoami"
#分发命令时设置命令的id
redis_send> rpsuh cmd_10.0.0.1 "whoami@@@@@9d21376cd47911e99464000c295dd589"
#查看主机执行过命令列表
redis_log> lrange log_host_10.0.0.1 0 100
#session_all开头的key即为select参数的等号右边命令返回值，返回值用于在设置select参数时进行参考
redis_send>keys session_all*
#设置select参数的值，设置后才会继续运行下一行命令（只插入一个值），一个select_all对应一个select
redis_send>rpush select@@@@@a20fb0fcd6ec11eaadc7000c295dd589 "aaa bbb ccc"
```


## 锁  
```shell
#内部使用两种锁机制用于安全控制（防止启动远程连接时执行错误的过期命令）以及阻塞冗余操作（对同一主机上传多次相同文件通过复制代替）
#特殊情况下需要手动释放锁（启动远程连接时提示命令存在、上传文件时出现异常的长时等待）
#查看主机的锁
python script/solve_lock.py 10.0.0.1 
#更详细的查看
python script/solve_lock.py -a 10.0.0.1
#释放锁 需要根据提示输入
python script/solve_lock.py -r 10.0.0.1 
#强制释放锁 需要根据提示输入
python script/solve_lock.py -f 10.0.0.1 
```