#! /bin/bash
container='dataone' # 容器名
newVolume='zdmission' # 新建的数据卷名

# 请确保你创建了数据卷和使用该数据卷的容器（即下边的mongo-yapi）

docker run -it --rm --volumes-from mongo-yapi -v $(pwd):/backup mongo tar cvf /backup/backupdata.tar /data/db

if [ $? -ne 0 ]
then
		echo "command faild! error：你可能没有创建mongo-yapi容器哦，请查看说明"
		exit 4
else 
		echo "command successfully! "$?
fi

# 创建一个临时容器，当然可以潜在的创建的一个数据卷并且可以命名，如下zdmission就是数据卷名称
# docker run -itd -v zdmission:/data/db --name data1 mongo /bin/bash

# 创建zdmission数据卷以及dataone容器，这个不要使用--rm配置，后续会用到dataone
docker run -itd -v $newVolume:/data/db --name $container mongo /bin/bash

if [ $? -ne 0 ]
  then
      echo "command faild! "$?
      exit 4
  else 
		  echo "command successfully! "$?
fi

# 解压我们打包的数据，迁移到我们新创建的zdmission数据卷中
docker run --rm --volumes-from $container -v $(pwd):/backup mongo tar xvf /backup/backupdata.tar

if [ $? -ne 0 ]
  then
      echo "command faild! "$?
      exit 4
  else 
      echo "command successfully! "$?
fi

docker rm -v $(docker stop $container)

if [ $? -ne 0 ]
  then
      echo "command faild! "$?
      exit 4
  else 
      echo "command successfully! "$?
fi

echo '恭喜您完成数据备份, 请查看'$newVolume