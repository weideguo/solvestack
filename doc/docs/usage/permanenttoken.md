创建token用于调用api  


### 创建表  
字段说明参考[solve-backend/auth_new/models.py](https://github.com/weideguo/solve-backend/blob/master/auth_new/models.py#L35-L60)
```sql
CREATE TABLE IF NOT EXISTS "auth_new_permanenttoken" (
"id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,  
"token" varchar(32) NOT NULL UNIQUE,              
"username" varchar(150) NOT NULL,                 
"invoke_rule_ids" varchar(200) NOT NULL,          
"is_validate" integer NOT NULL,                   
"validate_date" datetime NULL,                    
"create_date" datetime NOT NULL,                  
"max_invoke" integer NOT NULL,                    
"invoke_count" integer NOT NULL,                  
"invoke_success_count" integer NOT NULL,          
"lastest_date" datetime NULL,                     
"lastest_success_date" datetime NULL              
);

CREATE TABLE IF NOT EXISTS "auth_new_apiinvokerule" (
"id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
"path" varchar(100) NULL, 
"source" varchar(512) NULL, 
"method" varchar(50) NULL, 
"params" varchar(512) NULL, 
"body" varchar(512) NULL
);
```

### 生成token  
```shell
openssl rand -hex 16

```

### 插入数据库  
``` sql
insert into auth_new_permanenttoken
(
id, 
token, 
username, 
create_date, 
validate_date, 
max_invoke, 
invoke_count, 
invoke_success_count, 
invoke_rule_ids, 
is_validate
)
values
(
1,
'675ab0baa7f747813903e8b7dbd14de3',
'admin',
'2023-04-12 20:00:00', 
'2023-05-10 20:00:00',
9999,
0,
0,
'1,4',
-1
);

insert into auth_new_apiinvokerule 
(id,path,source,method,params,body)
values 
(1, '["/api/v1/target/info"]', '["127.0.0.1"]', '["GET","POST"]', '[{"a": "aaaa", "v": "vvv"},{"a": "aaa"},{"a": "aaaaa"}]', '[{"a": "aaaa", "v": "vvv"}]');
insert into auth_new_apiinvokerule values 
(2, '["/api/v1/target/stats"]', '["127.0.0.1"]', '["GET","POST"]', '[]', '[]');
insert into auth_new_apiinvokerule values 
(3, '["/api/v1/target/add"]', '["127.0.0.1"]', '["GET","POST"]', '[]', '[{"name": "server_.*", "v": "vvv"}]');
insert into auth_new_apiinvokerule values 
(
4, 
'["/api/v1/target/update"]', 
'["127.0.0.1"]', 
'["GET","POST"]', 
'[{"a": "a.*", "b": "b.*"}]', 
'[{"name": "server_.*", "v": "v.*"}]'
);
```

### 通过token调用api    
``` shell
permanent_token="675ab0baa7f747813903e8b7dbd14de3"
# 通过header使用
curl  "http://127.0.0.1:8000/api/v1/home/info" -H "Authorization:permanent_token ${permanent_token}"
# 通过请求url使用
curl  "http://127.0.0.1:8000/api/v1/home/info?permanent_token=${permanent_token}"
```
