# 基于 alpine镜像构建
FROM alpine:3.8
# 镜像维护者的信息
LABEL MAINTAINER = 'crper@outlook.com(https://github.com/crper)'
# 基础环境构建
# - 替换国内源,速度杠杠的
# - 更新源
# - 安装基础环境包
# - 不用更改默认shell了,只要进入的镜像的时候指定shell即可
# - 最后是删除一些缓存
# - 克隆项目
# - 采用自动化构建不考虑国内npm源了 , 可以降低初始化失败的概率
# !! yapi 官方的内网部署教程: https://yapi.ymfe.org/devops/index.html
RUN apk update \
  && apk add --no-cache  git nodejs nodejs-current-npm bash vim tar curl python python-dev py-pip gcc libcurl make\
  && usermod -s /bin/bash root \
  && rm -rf /var/cache/apk/* \
  && mkdir /yapi && cd /yapi && git clone https://github.com/YMFE/yapi.git vendors \
  &&  npm i -g node-gyp yapi-cli \
  && npm i --production;
# 工作目录
WORKDIR /yapi/vendors
# 配置yapi的配置文件
COPY config.json /yapi/
# 复制执行脚本到容器的执行目录
COPY entrypoint.sh /usr/local/bin/
# 写好的vim配置文件复制进去
COPY .vimrc /root/
# 向外暴露的端口
EXPOSE 3000

# 指定配置文件
ENTRYPOINT ["entrypoint.sh"]


# `shadow`: `alpine`默认不集成`usermod`,所以需要这个额外包,因为要用来更改默认`shell`
# `vim` : 编辑神器
# `tar` : 解压缩
# `make`: 编译依赖的
# `gcc`:  GNU编译器套装
# `python`: `python python-dev py-pip`这三个包包括了基本开发环境
# `curl` 可以测试连接也能下载内容的命令行工具
# `git` : 不用说了
# `nodejs` : node
# `nodejs-current-npm` : `alpine`Linux版本需要依赖这个版本,才能让`npm`识别到