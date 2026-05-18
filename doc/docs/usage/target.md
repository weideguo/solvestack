# target  


hash类型的redis key。执行对象本质即为参数的集合，用于在实际执行时对playbook进行变量替换，得到实际的要执行的命令。执行对象可以通过执行对象名的引用实现多层级参数。

* 特殊执行对象 `realhost_<ip>` `realhost_<ip>_<tag>`

  以realhost_开头的特殊执行对象存储创建ssh连接的信息。如realhost_10.0.0.1，则存储10.0.0.1的创建ssh连接的信息，playbook使用`[10.0.0.1]`命令创建ssh连接时使用该配置信息。
  带有tag主要用于标记同一ip不同配置，可以为任意值，如 realhost_10.0.0.1_xxx，playbook使用`[10.0.0.1_xxx]`命令创建ssh连接。
  
  字段说明：

  |   参数名    | 说明 | 必须 |
  | :---: | :----: | :--: |
  | ip        | 创建ssh连接用的ip，也可以为ip_tag（需要与key的名字一致）                 | 是 |
  | user      | 创建ssh连接用的user，不设置则默认root                                    | -  |
  | ssh_port  | ssh的端口，不设置则默认22                                                | -  |
  | passwd    | ssh的密码，在主机设置免密登陆时则不需要设置                              | -  |
  | proxy     | solve的代理，不是ssh代理。使用的代理名，对应proxy的mark，不设置则为直连  | -  |

  免密登陆：默认加载 ~/.ssh/ 下的 id_rsa 或 id_dsa 或 id_ecdsa
  
  SSH代理： 默认使用文件 ~/.ssh/config 的代理设置，Host需要对应ip（不是ip_tag），只需要ProxyCommand模块的设置。支持设置多级代理（如 hostA->hostB->hostC->hostD，只需要在hostA的配置文件设置）。代理机必须设置免密连接。（需要设置加载 ~/.ssh/ 下的文件 id_rsa 或 id_dsa 或 id_ecdsa ）

* 普通执行对象
  
  普通的存储信息的对象
::: v-pre
  如执行对象A为 `{"a":"A1","b":"bbb"}`，关联的对象A1为 `{"a1":"a111"}`，则playbook可以使用变量`{{a.a1}}`，替换后为`"a111"`
:::
