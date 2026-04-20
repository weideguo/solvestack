###### 发布新版本

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
