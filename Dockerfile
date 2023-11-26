# 打包依赖阶段使用golang作为基础镜像
FROM golang:1.20.6 as builder

# 启用go module
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

WORKDIR /app

COPY . .

# 指定OS等，并go build
RUN GOOS=linux GOARCH=amd64 go build -o main main.go 

# 由于我不止依赖二进制文件，还依赖views文件夹下的html文件还有assets文件夹下的一些静态文件
# 所以我将这些文件放到了publish文件夹
RUN mkdir publish && cp main publish 

# 运行阶段指定scratch作为基础镜像
FROM frolvlad/alpine-glibc:alpine-3.17_glibc-2.34 as runner 

WORKDIR /app

# 将上一个阶段publish文件夹下的所有文件复制进来
COPY --from=builder /app/publish .

# 指定运行时环境变量
ENV GIN_MODE=release \
    PORT=80

EXPOSE 80

ENTRYPOINT ["./main"]
