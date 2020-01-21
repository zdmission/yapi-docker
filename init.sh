#! /bin/bash

# 查询挂在的含有mongo_data_yapi字眼的数据卷名称
volid=`docker volume ls | grep mongo_data_yapi | awk '{print $2}'`

# 没有数据卷，开始创建
if [ ! $volid ]
then 
  echo '没有数据卷mongo_data_yapi，请稍等正在创建中...'
  docker volume create mongo_data_yapi
  echo '没有数据卷mongo_data_yapi创建成功'
fi

# 启动mongo，并挂在数据卷
docker run -d --name mongo-yapi -v mongo_data_yapi:/data/db mongo

# 获取zd-yapi镜像名称
imgId=`docker images | grep zd-yapi | awk '{print $1}'`

# 没有zd-yapi镜像就去先构建镜像
if [ ! $imgId ]
then
  echo `请先创建镜像，执行命令 docker build -t zd-yapi .`
fi

# 初始化yapi服务，建立容器连接，指定入口点，工作目录, 默认工作目录是/yapi/vendors，镜像内指定的入口点是node，但需要npm来初始化，所以要配置entrypoint
docker run -it --rm \
--link mongo-yapi:mongo \
--entrypoint npm \
--workdir /yapi/vendors \
zd-yapi \
run install-server

sleep 3
# 启动yapi服务，默认工作目录是/yapi/vendors，镜像内指定的入口点是node，所以可以省略node命令，直接server/app.js即可
docker run -d \
  --name web-yapi \
  --link mongo-yapi:mongo \
  --workdir /yapi/vendors \
  -p 9527:9527 \
  zd-yapi \
  server/app.js


