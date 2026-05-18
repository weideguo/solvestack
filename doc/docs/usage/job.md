# job  

由[playbook](./playbook)和[执行对象](./target)可以构建成一个任务。

### job的参数说明 ###

|   参数名   | 说明 | 必须 |
| :---: | :----: | :--: |
| target     | 执行对象的列表，使用","分隔                                    | 是 |
| playbook   | 对应的playbook（绝对路径，或者参照playbook目录的相对路径）     | 是 |
| session    | 用于引入临时的参数，如果playbook中使用session参数，则必须设置  | - |
| begin_line | 从第playbook的第几行开始执行                                   | - |
