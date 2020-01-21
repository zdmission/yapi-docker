#! /bin/bash

# 确保你的yapi相关mongo数据库已经初始化完毕，数据库只能初始化一次，再次初始化会报错的
# 启动mongo，并挂在数据卷
docker run -d --name mongo-yapi -v mongo_data_yapi:/data/db mongo

echo 'mongo_data_yapi数据卷挂载成功'

# 启动yapi服务
docker run -d \
  --name web-yapi \
  --link mongo-yapi:mongo \
  --workdir /yapi/vendors \
  -p 9527:9527 \
  zd-yapi \
  server/app.js

if [ $? -ne 0 ]
  then
      echo "command faild! "$?
      exit 4
  else 
      echo "command successfully! "$?
fi

echo 'yapi服务启动成功，访问地址http://127.0.0.1:9527'