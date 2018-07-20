#!/bin/sh

# yapi初始化后会有一个init.lock文件
lockPath="/yapi/init.lock"
# yapi配置文件
configPath="/yapi/config.json"


# 进入yapi项目
cd /yapi/vendors


# 如果初始化文件文件存在,则直接运行,否则初始化
if [ ! -f "$lockPath" ]; then
  # 启动Yapi初始化
  node server/install.js
  # 若是初始化成功的情况下直接运行yapi
  node server/app.js
else
  if [! -f "$configPath" ];then
    # 判断传入的第一个参数是否为字符串"update"
    if[ "$1" = "update" ];then
      cd /yapi && yapi update
      cd /yapi/vendors && node server/app.js
    else
      # 运行yapi管理系统
      node server/app.js
    fi
fi