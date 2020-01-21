#! /bin/bash
containers=`docker ps | grep -E "(mongo-yapi|web-yapi)" | awk '{print $1}'`

if [ ${#containers[@]} != 0 ]
then
  docker stop $containers

  # 删除容器并且删除启动容器时对应的数据卷
  docker rm -v $containers
fi

echo "相关容器已被停止并且删除"