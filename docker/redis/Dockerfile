# redis Dockfile
# Version 1.0

# Base images 
FROM redis:4.0
LABEL maintainer="wdg(https://github.com/zouzhicun)"

#use exist file for redis data
ADD ./dump.rdb   /data/

CMD ["redis-server"]