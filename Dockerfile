# 打包依赖阶段使用golang作为基础镜像
FROM golang:1.20.6 as builder

# 启用go module
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

WORKDIR /app

COPY . .

# 指定OS等，并go build
RUN GOOS=linux GOARCH=amd64 go build -o main main.go 

# 指定运行时环境变量
ENV GIN_MODE=release \
    PORT=80

EXPOSE 80

ENTRYPOINT ["./main"]
