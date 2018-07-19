#!/bin/sh

# yapi初始化后会有一个init.lock文件
lockPath="/yapi/init.lock"

# 设置源为淘宝源
npm config set registry http://registry.npm.taobao.org/;

# 进入yapi项目
cd /yapi/vendors


# 如果初始化文件文件存在,则直接运行,否则初始化
if [ ! -f "$lockPath" ]; then
  # 全局安装用来更新yapi的cli
  npm i -g node-gyp yapi-cli;
  # 安装初始化的依赖模块
  npm i --production;
  # 启动Yapi初始化
  node server/install.js
else
  # 运行yapi管理系统
  node server/app.js
fi