#!/bin/env python
# -*- coding: utf-8 -*-
# 调用solvestack的接口执行工单
# by weideguo@dba 20250522
import sys
import time
import requests



base_usl = "http://10.0.0.01:8000"
permanent_token = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"                     
execution_name = "正式_使用archery获取mysql的show_processlist信息"    # 对应solve中“执行任务”的name


instance_name = "支付-阿里云-master"                               
feishu_token = "aaaaaaa-8888-4444-aaaa-0000000000#dba通知"    

#instance_name = sys.argv[1]
#feishu_token = sys.argv[2]


# 工单的参数
payload = {
"instance_name":instance_name,    
"feishu_token":feishu_token          
}

headers = {
"Content-Type": "application/json",
"Accept": "application/json",
"Authorization": f"permanent_token {permanent_token}"
}


# 提交session参数（不是必须）
#r = requests.post(f"{base_usl}/api/v1/session/?filter=exec:{execution_name}", headers=headers, json=payload)
#print(r.text)

# 执行工单
_r = requests.post(f"{base_usl}/api/v1/execution/?filter=exec:{execution_name}", headers=headers, json=payload)
r = _r.json()

if (not "status" in r) or (not "data" in r) or (r["status"] != 1):
    print(r.text)
    print("提交执行任务失败")
    exit(1)

workid = r["data"]
print("提交执行任务成功")


time.sleep(10)
_r = requests.get(f"{base_usl}/api/v1/order/detail?workid={workid}&exclude=", headers=headers)
r = _r.json()

if (not "status" in r) or (not "data" in r) or (r["status"] < 0):
    print(r.text)
    print("获取查询结果失败")
    exit(1)

r = _r.json()

for r_info in r["data"]:
    if "exe_status" in r_info:
        print(r_info["exe_status"])
    else:
        print(r_info)


# 获取工单汇总
# GET
url = f"{base_usl}/api/v1/order/summary?workid={workid}"

