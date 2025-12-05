###### 手动构建镜像
# solve
# docker build -t solve:latest -f Dockerfile .
docker build -t solve:latest \
--build-arg INDEX_URL=https://mirrors.aliyun.com/pypi/simple/ \
--build-arg TRUSTED_HOST=mirrors.aliyun.com  \
-f Dockerfile .      
# solve-backend
docker build -t solve-backend:latest \
--build-arg INDEX_URL=https://mirrors.aliyun.com/pypi/simple/ \
--build-arg TRUSTED_HOST=mirrors.aliyun.com  \
-f Dockerfile .
# solve-frontend
docker build -t solve-frontend:latest \
--build-arg REGISTRY=https://registry.npm.taobao.org/  \
-f Dockerfile .


###### 单个容器启动
docker run \
--name solve \
--env REDIS_HOST=192.168.253.128 \
-v /tmp:/tmp \
-d \
<solve_images_id>

docker run \
--name solve-backend \
--env REDIS_HOST=192.168.253.128 \
-p 8000:8000 \
-v /tmp:/tmp \
-d \
<solve-backend_images_id>

docker run \
--name solve-frontend \
--env REDIS_HOST=192.168.253.128 \
-p 8080:8080 \
-d \
<solve-frontend_images_id>



###### 发布新版本
# 更新源码

# 修改参数，至少需要修改版本号
vim .env


# 构建镜像
docker-compose build solve
docker-compose build solve-backend
docker-compose build solve-frontend

# 运行
docker-compose up -d solve
docker-compose up -d solve-backend
docker-compose up -d solve-frontend

# 进入solve容器
docker exec -it solve_solve_1 bash
# 手动安装以下依赖
apt update && apt install -y sshpass pv

# 如果更新前端项目，需要替换以下文件
docker cp highlight/prism-bash.js \
solve_solve-frontend_1:/data/solve-frontend/node_modules/prismjs/components/prism-bash.js
