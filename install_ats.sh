#!/bin/bash

rm -rf trafficserver; git clone https://git-wip-us.apache.org/repos/asf/trafficserver.git; pushd trafficserver

autoreconf -if

./configure --prefix=/opt/ts

make

make check

make install
