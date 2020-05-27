#coding:UTF-8
import datetime
import time
import redis
from redis.sentinel import Sentinel

sentinel = Sentinel([('127.0.0.1', 26379),
                     ('127.0.0.1', 26380),
                     ('127.0.0.1', 26381)],
                     socket_timeout=0.1)
sentinel.discover_master('mymaster')
master = sentinel.master_for('mymaster', socket_timeout=0.1)
#slave = sentinel.slave_for('mymaster', socket_timeout=0.1)

i = 0

while True:
    try:
        k = str(i)
        v = str(datetime.datetime.now())
        # Write to the master
        rslt = master.get(k)
        print rslt

    except redis.exceptions.TimeoutError:
        print str(datetime.datetime.now()), " Socket time out"

    except redis.exceptions.ConnectionError:
        print str(datetime.datetime.now()), " Connection Error"

    except redis.sentinel.MasterNotFoundError:
        print str(datetime.datetime.now()), " Master not found"

    except redis.exceptions.ReadOnlyError:
        print str(datetime.datetime.now()), " Readonly Error"

    except KeyboardInterrupt:
        break

    except Exception as e:
        print "%s" % e.message

    time.sleep(0.01)
    i += 1
