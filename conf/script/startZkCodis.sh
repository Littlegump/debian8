#!/bin/bash

PATH=$PATH:/root/go/src/github.com/CodisLabs/codis/bin

# start ZooKeeper
rm -rf /data/zookeeper/ && mkdir -p /data/zookeeper/{01,02,03}
echo 1 > /data/zookeeper/01/myid
echo 2 > /data/zookeeper/02/myid
echo 3 > /data/zookeeper/03/myid

cat > /data/zookeeper/zoo1.cfg <<EOF
tickTime=2000
dataDir=/data/zookeeper/01
dataLogDir=/data/zookeeper/01
clientPort=2181
initLimit=5
syncLimit=2
server.1=0.0.0.0:2888:3888
server.2=0.0.0.0:2889:3889
server.3=0.0.0.0:2890:3890
EOF
cat > /data/zookeeper/zoo2.cfg <<EOF
tickTime=2000
dataDir=/data/zookeeper/02
dataLogDir=/data/zookeeper/02
clientPort=2182
initLimit=5
syncLimit=2
server.1=0.0.0.0:2888:3888
server.2=0.0.0.0:2889:3889
server.3=0.0.0.0:2890:3890
EOF
cat > /data/zookeeper/zoo3.cfg <<EOF
tickTime=2000
dataDir=/data/zookeeper/03
dataLogDir=/data/zookeeper/03
clientPort=2183
initLimit=5
syncLimit=2
server.1=0.0.0.0:2888:3888
server.2=0.0.0.0:2889:3889
server.3=0.0.0.0:2890:3890
EOF
pushd /usr/local/zookeeper
./bin/zkServer.sh start /data/zookeeper/zoo1.cfg
./bin/zkServer.sh start /data/zookeeper/zoo2.cfg
./bin/zkServer.sh start /data/zookeeper/zoo3.cfg

rm -rf /data/tmp; mkdir -p /data/tmp && pushd /data/tmp

cat > proxy1.toml <<EOF
product_name="codisInstance"
product_auth=""
proto_type="tcp4"
admin_addr="0.0.0.0:11080"
proxy_addr="0.0.0.0:19000"
EOF
cat > proxy2.toml <<EOF
product_name="codisInstance"
product_auth=""
proto_type="tcp4"
admin_addr="0.0.0.0:11081"
proxy_addr="0.0.0.0:19001"
EOF
cat > proxy3.toml <<EOF
product_name="codisInstance"
product_auth=""
proto_type="tcp4"
admin_addr="0.0.0.0:11082"
proxy_addr="0.0.0.0:19002"
EOF
cat > redis1.conf <<EOF
port 6379
dbfilename dump1.rdb
EOF
cat > redis2.conf <<EOF
port 6380
dbfilename dump2.rdb
EOF
cat > redis3.conf <<EOF
port 6381
dbfilename dump3.rdb
EOF
cat > redis4.conf <<EOF
port 6382
dbfilename dump4.rdb
EOF
cat > redis5.conf <<EOF
port 6383
dbfilename dump5.rdb
EOF
cat > redis6.conf <<EOF
port 6384
dbfilename dump6.rdb
EOF
cat > codis.json <<EOF
[
  {
    "name": "codisInstance",
    "dashboard": "127.0.0.1:18080"
  }
]
EOF
cat >dashboard.toml <<EOF
coordinator_name = "zookeeper"
coordinator_addr = "127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183"
product_name = "codisInstance"
product_auth = ""
admin_addr = "0.0.0.0:18080"
EOF

nohup codis-dashboard -c dashboard.toml &> dashboard.log &
if [ $? -ne 0 ];then
  echo "codis-Dashboard start failed"
  exit 1
fi

nohup codis-server redis1.conf &> redis-6379.log &
nohup codis-server redis2.conf &> redis-6380.log &
nohup codis-server redis3.conf &> redis-6381.log &
nohup codis-server redis4.conf &> redis-6382.log &
nohup codis-server redis5.conf &> redis-6383.log &
nohup codis-server redis6.conf &> redis-6384.log &
if [ $? -ne 0 ];then
  echo "codis-server start failed"
  exit 1
fi
nohup codis-proxy -c proxy1.toml &>proxy1.log &
nohup codis-proxy -c proxy2.toml &>proxy2.log &
nohup codis-proxy -c proxy3.toml &>proxy3.log &
if [ $? -ne 0 ];then
  echo "codis-proxy start failed"
  exit 1
fi
nohup /root/go/src/github.com/CodisLabs/codis/bin/codis-fe -d codis.json --listen 0.0.0.0:8080 &> fe.log &
if [ $? -ne 0 ];then
  echo "codis-FE start failed"
  exit 1
fi
nohup codis-ha --dashboard=127.0.0.1:18080 &> codis_ha.log &
if [ $? -ne 0 ];then
  echo "codis-HA start failed"
  exit 1
fi
codis-admin --dashboard=127.0.0.1:18080 --create-group --gid 1
codis-admin --dashboard=127.0.0.1:18080 --create-group --gid 2
codis-admin --dashboard=127.0.0.1:18080 --create-group --gid 3
codis-admin --dashboard=127.0.0.1:18080 --group-add --gid 1 -x 127.0.0.1:6379
codis-admin --dashboard=127.0.0.1:18080 --group-add --gid 1 -x 127.0.0.1:6380
codis-admin --dashboard=127.0.0.1:18080 --group-add --gid 2 -x 127.0.0.1:6381
codis-admin --dashboard=127.0.0.1:18080 --group-add --gid 2 -x 127.0.0.1:6382
codis-admin --dashboard=127.0.0.1:18080 --group-add --gid 3 -x 127.0.0.1:6383
codis-admin --dashboard=127.0.0.1:18080 --group-add --gid 3 -x 127.0.0.1:6384
codis-admin --dashboard=127.0.0.1:18080 --create-proxy -x 127.0.0.1:11080
codis-admin --dashboard=127.0.0.1:18080 --create-proxy -x 127.0.0.1:11081
codis-admin --dashboard=127.0.0.1:18080 --create-proxy -x 127.0.0.1:11082
codis-admin --dashboard=127.0.0.1:18080 --slot-action --interval=100
codis-admin --dashboard=127.0.0.1:18080 --rebalance --confirm

while true; do
    date
    sleep 60
done
