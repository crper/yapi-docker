# 基于 alpine镜像构建
FROM alpine:3.8
# 镜像维护者的信息
LABEL MAINTAINER = 'crper@outlook.com(https://github.com/crper)'
# 基础环境构建
# - 替换国内源,速度杠杠的
# - 更新源
# - 安装基础环境包
# - 更改用户的默认shell , 因为容器只是给yapi用,所以就不考虑创建用户组和独立用户这种东西,所以只有root用户了
#   ,若是容器包括多功能就需要用户组这些好一些(不推荐容器有太多功能),尽可能保持容器功能的单一性
# - 最后是删除一些缓存
# - 克隆项目
# !! yapi 官方的内网部署教程: https://yapi.ymfe.org/devops/index.html
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  && apk update \
  && apk add --no-cache shadow git nodejs nodejs-current-npm bash vim tar curl python python-dev py-pip gcc libcurl make\
  && usermod -s /bin/bash root \
  && rm -rf /var/cache/apk/* \
  && mkdir /yapi && cd /yapi && git clone https://gitee.com/mirrors/YApi.git vendors
# 工作目录
WORKDIR /yapi/vendors
# 配置yapi的配置文件
COPY config.json /yapi/
# 复制执行脚本到容器的执行目录
COPY entrypoint.sh /usr/local/bin/
# 写好的vim配置文件复制进去
COPY .vimrc ~/
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