#!/bin/sh

# yapi初始化后会有一个init.lock文件
lockPath="/yapi/init.lock"

# 如果初始化文件文件存在,则直接运行,否则初始化
if [ ! -f "$lockPath" ]; then
  cd /yapi/vendors/;
  npm i -g node-gyp yapi-cli --registry https://registry.npm.taobao.org;
  npm i --production --registry https://registry.npm.taobao.org;
  node /yapi/vendors/server/install.js
else
  node /yapi/vendors/server/app.js
fi