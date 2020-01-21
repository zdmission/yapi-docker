#! /bin/bash

docker build -t zd-yapi .

# 指定其他文件名的dockerfile文件构建镜像
# docker build -f ./docker_test_file -t zd-yapi .