# yapi相关配置以及其他shell脚本使用说明

Dockerfile文件是制作yapi镜像的基础文件

## 一、config.json文件

> 是初始化yapi数据库以及服务的一些配置信息

[官网配置参考config_example.json](https://github.com/YMFE/yapi/blob/master/config_example.json?spm=5176.1972344.1.6.LYdCBe&file=config_example.json)

## 二、init.sh

> 初始化并且启动mongodb数据库和yapi服务，yapi相关数据库信息只需要初始化一次，再次初始化会报错

## 三、start.sh

> 启动mongo数据库和yapi的服务

## 四、stop.sh

> 停掉yapi相关数据库和服务的容器并且删除对应的容器以及容器相关的数据卷

## 五、backup_volume.sh 一键备份已有的数据卷

> 创建一个和原来数据卷有同样的数据的数据卷，back_volume.md是介绍docker备份，恢复以及迁移数据卷的文档

## 六、create-image.sh

> 根据Dockerfile文件制作一个yapi的镜像，可做修改