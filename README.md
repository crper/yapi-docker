# Yapi Docker

> YApi 是一个可本地部署的、打通前后端及QA的、可视化的接口管理平台 [yapi.ymfe.org](https://github.com/YMFE/yapi)


---

# 提供的内容

**第一次初始化默认拉取的最新的版本,所以不用指定版本,若是yapi代码不严谨,连新版本初始化都会报错则无解!**

- `yapi`的部署
- `yapi`的升级


---

# 创建volume

- `docker volume create yapi-mongo`

创建一个储存卷,用来专门存放`yapi`使用的`mongodb`的数据

为什么要独立出来,这是为了以后升级的着想,数据库保留,只要启动的时候关联一下就行了



---

# 启动mongodb

- `docker run -d --name yapi-mongo -v yapi-mongo:/data/db mongo`


为什么要先启动`mongodb`,因为`yapi`初始化的时候依赖`mongodb`,比如创建用户表这些

这条命令是什么意思呢?

```bash

-d : 是启动的时候输出容器的id
--name : 是给容器设置一个名字,方便我们控制,比如start,stop
-v : 指定关联的卷 => 本地卷:容器内储存位置 , 就是映射数据保存的地方

```

若是需要外部管理这个数据库的话,最好也暴露出来端口, `mongodb`容器默认也暴露了27017端口

- `docker run -d --name yapi-mongo -v yapi-mongo:/data/db -p 27017:27017 mongo`

---

# 初始化Yapi和启动Yapi

- `docker run -d --name yapi -p 3000:3000 --link yapi-mongo  crper/yapi`


这里比上面多的一个参数就是`--link`,用来使连个容器通讯的,过时命令,官方已经不推荐

**过程均可用**`docker logs details 容器ID或者name`来看到内部的情况

就是`shell`执行过程,比如这个项目就可以在初始化的时候,看到初始化的账号密码(成功)


不管是`mongo`还是`crper/yapi` ,当你请求一个容器不存在的时候,

会尝试往`dockhub`上面找,默认拉取镜像`latest`版本,找不到才会报错

以下就是基本的初始化信息

```bash
访问链接: 127.0.0.1:3000
默认的账户名: config.json =>  adminAccount 这个字段的值
密码: ymfe.org
```


---

# 升级yapi

## 手动升级

因为不涉及到容器处理..只是单纯的文件替换,官方也提供了方案,那个`cli`已经默认集成到容器里面

```javascript
// https://yapi.ymfe.org/devops/index.html
cd  {项目目录}
yapi ls //查看版本号列表
yapi update //升级到最新版本
yapi update -v v1.1.0 //升级到指定版本
```

升级完毕重启`node`程序亦或者重启容器即可!!



----

# 错误

在初始化的时候,执行

`docker logs --details 容器ID`

查看内部终端的执行过程,npm的一些源也不一定靠谱,

若是提示`npm`安装报错了,就需要进去换其他源了

先启动`crper/yapi`镜像,然后跟着教程走



```javascript
// npm config set registry [url]
// npm ---- https://registry.npmjs.org/
// cnpm --- http://r.cnpmjs.org/
// taobao - http://registry.npm.taobao.org/
// eu ----- http://registry.npmjs.eu/
// au ----- http://registry.npmjs.org.au/
// sl ----- http://npm.strongloop.com/
// nj ----- https://registry.nodejitsu.com/


// 进入到vendors目录
// 若是有node_modules目录,
// 我们都应该先干掉node_modules
// 这样重新安装依赖才会比较干净

// 进到vendors目录, 比如设置回官方源
npm config set registry https://registry.npmjs.org/;

// 安装全局升级工具和依赖编译的npm模块
npm i -g node-gyp yapi-cli \
npm i --production;

// 初始化 yapi
node server/install.js

```

依赖安装完成就可以再重新初始化,然后重启容器即可
