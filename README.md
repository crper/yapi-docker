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


不管是`mongo`还是`crper/yapi` ,当你请求一个容器不存在的时候,

会尝试往`dockhub`上面找,默认拉取镜像`latest`版本,找不到才会报错

没有报错的话,会直接输出一个容器ID,重启下容器即可使用(因为第一次执行是初始化,第二次运行之后才会直接启动程序,看`sh`)

`docker restart yapi`

```bash
访问链接: 127.0.0.1:3000
默认的账户名: config.json =>  adminAccount 这个字段的值
密码: ymfe.org
```

---

# 升级yapi

因为不涉及到容器处理..只是单纯的文件替换,官方也提供了方案,那个`cli`已经默认集成到容器里面

```javascript
// https://yapi.ymfe.org/devops/index.html
cd  {项目目录}
yapi ls //查看版本号列表
yapi update //升级到最新版本
yapi update -v v1.1.0 //升级到指定版本
```

升级完毕重启`node`程序亦或者重启容器即可!!
