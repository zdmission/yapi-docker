# yapi数据，docker数据卷备份和恢复

> 在实际运用中，在一台机子上的数据可能会迁移到另一个地方，这个时候我们怎么备份我们现有的数据呢？其次备份好了又怎么在另一个地方使用呢？

## docker数据卷迁移主要步骤（确保你要备份的数据卷的相关容器已经启动）

- 1.对现有的volume打包，文件格式tar或者tar.gz，删除容器
- 2.拷贝或者上传压缩包到你的目的机器
- 3.在新机器上创建中间容器，并且命名挂在的数据卷（否则就变成匿名数据卷了，不方便辨认）
- 4.接下来是创建容器解压文件到数据卷对应的目录
- 5.删除中间过渡的容器以及对应的数据卷信息

## 接下来我们按照上边的步骤一步一步实现数据的备份和恢复以及启动服务

- 一、对现有的volume打包，文件格式tar或者tar.gz

```bash
# mongo-yapi为已经启动的容器（创建容器参考docker run -d --name mongo-yapi -v mongo_data_yapi:/data/db mongo）
# 其中mongo_data_yapi是已经创建的数据卷

# $(pwd)是当前项目的路径

# /backup 为容器内备份目录

# mongo 是镜像

# tar cvf /backup/backupdata.tar -C /data/db ./

# /backup/backupdata.tar 为什么要这样写，是前边做了对应，/backup这个目录对应了$(pwd)当前项目的路径

# -C 参数可以避免打包的文件中出现了我么不需要的目录，比如我们想打包/usr/lib/nignx下的所有文件，最后解压出来的文件不会包含/usr/lib/nginx目录，这是参考别人的，在本说明中未操作
docker run -it --rm --volumes-from mongo-yapi -v $(pwd):/backup mongo tar cvf /backup/backupdata.tar /data/db
```

- 二、拷贝或者上传压缩包到你的目的机器（这个目前在本机就省略了）
- 三、在新机器上创建中间容器，并且命名挂在的数据卷（否则就变成匿名数据卷了，不方便辨认）

```bash
# 这个创建的中间容器会用到，所以不要使用--rm
# zdmission:/data/db 是给数据卷起名了叫zdmission
# /bin/bash 交互模式是bash风格的
docker run -itd -v zdmission:/data/db --name dataone mongo /bin/bash

# 通过docker volume ls 查看zdmission数据卷
```

- 四、接下来是创建容器解压文件到数据卷对应的目录

```bash
# 数据卷来源--volumes-from它的值是一个特殊的容器，即dataone
docker run --rm --volumes-from dataone -v $(pwd):/backup mongo tar xvf /backup/backupdata.tar
```

- 五、删除中间过渡的容器以及对应的数据卷信息(看情况想删除就删)

- 六、利用新创建zdmission数据卷创建mongo的容器mongo-yapi2

```bash
docker run -d --name mongo-yapi2 -v zdmission:/data/db mongo
```

- 七、启动yapi服务
确保你已经有了yapi的镜像，并且已经初始化yapi的服务
```bash
docker run -d \
  --name web-yapi \
  --link mongo-yapi2:mongo \
  --workdir /yapi/vendors \
  -p 9527:9527 \
  qunar-yapi \
  server/app.js
```
