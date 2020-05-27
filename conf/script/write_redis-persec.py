#!/usr/bin/env python
# -*- coding: utf-8 -*-

import redis
import datetime
import sys
import logging
import time

IP_ADDRESS = '127.0.0.1'
PORT = 6379

r = redis.StrictRedis(host=IP_ADDRESS, port=PORT, db=10,
              socket_timeout=1,
              socket_connect_timeout=1)

i = 0
j = 0
while True:
    k = str(i)
    v = str(datetime.datetime.now())

    try:
        # Write to the master
        r.set(k, v)
        #logger.debug('%s %s' % (k, v))
        #print '%s %s' % (k, v)
        print k,v

    except redis.exceptions.TimeoutError:
        j += 1
        print j, str(datetime.datetime.now()), " Socket time out"
        time.sleep(1)

    except redis.exceptions.ConnectionError:
        j += 1
        print j, str(datetime.datetime.now()), " Connection Error"
        time.sleep(1)

    except KeyboardInterrupt:
        print "total key: %s" % i
        print "interrupted time : %s" % j
        break

    time.sleep(0.01)
    i += 1
