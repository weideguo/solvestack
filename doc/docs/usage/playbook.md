# playbook  


存储命令的文本文件，solve逐行读取并执行

## 单行命令的格式  
* `[<ip>]`
  
  主机跳转，每个脚本的第一条命令必须为主机跳转，每个playbook文件可以有一个或多个跳转语句，在表明之后的命令都在该主机执行 。命令之后不要存在空格。

* `<single-line shell command>`
  
  单行shell命令

* wait
  
  wait为关键字，阻塞至所有后台运行全命令结束。默认playbook的命令逐行运行，后一行命令在前一行命令执行结束后再运行，可以使用`<single-line shell command> &`实现将单行命令放入后台运行，从而不必阻塞后一行命令。默认在playbook的最后执行一次wait，以确保后台命令执行结束，因而最后的wait可以省略。

* ``global.<global_var_name>=<other string>`<shell command>`<other string>``
  
  全局参数可以通过执行shell命令的返回值获取。即符号“=”之后的字符串当成shell命令运行后的结果。如`$(shell command)`也是一样支持。

* ``select.<select_var_name>=<other string>`<shell command>`<other string>``

  与global参数使用类似，不同为其值为获取shell命令的返回值，再进行手动选择的值，用于交互执行。

* `# <comment>`

  \#开头的注释。不要在注释中包含jinja模板，即双括号包含字段如{{xxx}}

* `__<keyword>__`自定义扩展命令
  
  开头单词以 “__” 包围的命令行被当成扩展命令自定义实现，使用格式形同普通的shell，即 cmd arg1 args ...
  
  [./extend_command.md](./extend_command.md)


## 参数替换  
::: v-pre
所有命令可以使用`{{<var name>}}`指定参数为可替换参数，参数的来源
 
* global参数

  使用格式为`{{global.<global_var_name>}}`

  运行时替换为``global.<global_var_name>=<other string>`<shell command>`<other string>``全局参数的设置值

* select参数

  与global参数使用类似

* session参数

  使用格式为`{{session.<session_var_name>;}}`

  job中的session对应的参数

* 执行对象的属性

  如执行对象A为 `{"a":"aaa","b":"bbb"}`，则可以使用`{{a}}`，替换后为`"aaa"`

  多层级参数如`{{a.a1}}`，详见[执行对象](./target.md)的说明
:::