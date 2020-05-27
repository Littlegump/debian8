#!/bin/bash

# install go
wget https://dl.google.com/go/go1.5.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.5.2.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin:/root/go/bin" >> ~/.bashrc
echo """export GOPATH="$HOME/go"""" >> ~/.bashrc
source ~/.bashrc
go get -u github.com/tools/godep

# install redis
wget http://download.redis.io/releases/redis-5.0.8.tar.gz && tar xzf redis-5.0.8.tar.gz && cd redis-5.0.8 && make
ln -sv /data/redis-5.0.8/src/redis* /usr/bin/

# install codis
mkdir -p $GOPATH/src/github.com/CodisLabs
cd $_ && git clone https://github.com/CodisLabs/codis.git -b release3.0
cd $GOPATH/src/github.com/CodisLabs/codis && make

# install etcd
ETCD_VERSION=${ETCD_VERSION:-v3.3.1}

curl -L https://github.com/coreos/etcd/releases/download/$ETCD_VERSION/etcd-$ETCD_VERSION-linux-amd64.tar.gz -o etcd-$ETCD_VERSION-linux-amd64.tar.gz

tar xzvf etcd-$ETCD_VERSION-linux-amd64.tar.gz
rm etcd-$ETCD_VERSION-linux-amd64.tar.gz

cd etcd-$ETCD_VERSION-linux-amd64
cp etcd /usr/local/bin/
cp etcdctl /usr/local/bin/

rm -rf etcd-$ETCD_VERSION-linux-amd64

etcdctl --version

# install zookeeper
ZKPKG=zookeeper-3.4.14
wget -O $ZKPKG.tar.gz https://downloads.apache.org/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz
tar zxf $ZKPKG.tar.gz -C /usr/local
ln -s /usr/local/$ZKPKG /usr/local/zookeeper
