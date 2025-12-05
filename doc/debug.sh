cd  /home/weideguo/gitproject

docker run -it                                        \
--name solve-3.13                                     \
--network host                                        \
-v /home/weideguo/gitproject/solve:/data/solve        \
-v /etc/pip.conf:/etc/pip.conf                        \
-v /tmp/solve:/tmp/solve                              \
--privileged                                          \
docker.io/python:3.13                                 \
bash


mkdir -p /home/weideguo/gitproject/solve
ln -s /data/solve/playbook /home/weideguo/gitproject/solve/playbook

cd /data/solve
pip install -r requirements.txt

#nohup python bin/solve.py start > logs/solve.out 2>logs/solve.err & 
python bin/solve.py start 

apt update
apt install iproute2 sshpass pv -y








docker run -it                                                                          \
--name solve-be-3.13                                                                    \
--network host                                                                          \
-v /home/weideguo/gitproject/solve-backend:/data/solve-backend                          \
-v /etc/pip.conf:/etc/pip.conf                                                          \
-v /home/weideguo/gitproject/solve/playbook:/home/weideguo/gitproject/solve/playbook    \
-v /tmp/solve:/tmp/solve                                                                \
--privileged                                                                            \
python:3.13                                                                             \
bash



cd /data/solve-backend
pip install -r requirements.txt

python durable_server.py 
python manage.py runserver 0.0.0.0:8000 









docker run -it                                                                       \
--name solve-fe-16                                                                   \
--network host                                                                       \
-v /home/weideguo/gitproject/solve-frontend:/data/solve-frontend                     \
-v /root/.npmrc:/root/.npmrc                                                         \
--privileged                                                                         \
node:16.14                                                                           \
bash





docker run -it                                                                       \
--name solve-fe-22                                                                   \
--network host                                                                       \
-v /home/weideguo/gitproject/solve-frontend-new:/data/solve-frontend-new             \
-v /root/.npmrc:/root/.npmrc                                                         \
--privileged                                                                         \
node:alpine-v22.14.0                                                                 \
sh

#npm install -g @vue/cli@5.0.8
npm install -g @vue/cli


npm run serve -- --host 0.0.0.0 --port 5000


# 前端检查包依赖使用与否
depcheck

