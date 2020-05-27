import traceback
import datetime
from rediscluster import RedisCluster
startup_nodes = [
    {"host": "localhost", "port": "7001"},
    {"host": "localhost", "port": "7002"},
    {"host": "localhost", "port": "7003"},
    {"host": "localhost", "port": "7004"},
    {"host": "localhost", "port": "7005"},
    {"host": "localhost", "port": "7006"},
]

# decode_responses=True is required to have when running on python3
rc = RedisCluster(startup_nodes=startup_nodes,decode_responses=True)

i = 0
while True:

    value = str(datetime.datetime.now())
    try:
        rslt = rc.get(i)
    except Exception, exc:
        traceback.print_exc()

    i += 1
    print  i, value
