# 这个node版本包比较小，as取别名，在其他地方可以引用
FROM node:12-alpine as builder

# 作者信息
LABEL MAINTAINER="zdmission.cn"


# 执行命令，安装一些包，apk是很小的包管理工具，
RUN apk add --no-cache git python make openssl tar gcc && mkdir /zdmission

# 执行命令，下载yapi包，解压，移动之类的
RUN cd /zdmission && wget https://github.com/YMFE/yapi/archive/v1.8.5.tar.gz && tar zxvf v1.8.5.tar.gz && mkdir -p /yapi/vendors && mv /zdmission/yapi-1.8.5/* /yapi/vendors

# 在yapi文件的根目录下执行安装
RUN cd /yapi/vendors && \
    npm install --production --registry https://registry.npm.taobao.org

# 这个node版本包比较小
FROM node:12-alpine

# 环境变量
ENV TZ="Asia/Shanghai"

# 工作目录
WORKDIR /yapi/vendors

# 复制
COPY --from=builder /yapi/vendors /yapi/vendors

# RUN tee /api/config.json <<-'EOF' {"port":"9527","adminAccount":"zdmission@admin.com","db":{"servername":"mongo","DATABASE":"yapi","port":27017}} EOF

# 复制
COPY config.json /yapi/

# 暴露端口
EXPOSE 9527

# 入口点，让镜像变成像命令一样使用或者执行某个shell命令（应用运行前的准备工作）
ENTRYPOINT ["node"]