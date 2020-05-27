FROM yinkaixuan0213/debian8_base:latest

WORKDIR /data

ADD . /data

RUN pip install redis redis-py-cluster

# install redis
RUN wget http://download.redis.io/releases/redis-5.0.8.tar.gz && tar xzf redis-5.0.8.tar.gz && cd redis-5.0.8 && make

# make bin
RUN ln -sv /data/redis-5.0.8/src/redis* /usr/bin/

ENTRYPOINT ["/bin/bash","/data/entrypoint.sh"]
