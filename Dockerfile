FROM yinkaixuan0213/debian8_base:latest

WORKDIR /data

ADD . /data

# 固定版本 redis2.10.6 redis-py-cluster=1.3.6
RUN pip install redis==2.10.6 redis-py-cluster==1.3.6

# install redis
RUN wget http://download.redis.io/releases/redis-4.0.14.tar.gz && tar xzf redis-4.0.14.tar.gz && cd redis-4.0.14 && make

EXPOSE 6379 6380 6381

# make bin
RUN ln -sv /data/redis-4.0.14/src/redis* /usr/bin/

ENTRYPOINT ["/bin/bash","/data/entrypoint.sh"]
