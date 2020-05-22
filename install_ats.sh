#!/bin/bash
git clone https://git-wip-us.apache.org/repos/asf/trafficserver.git
if [$? -eq 0]; then
  pushd trafficserver
  autoreconf -if
  ./configure --prefix=/opt/ts
  make
  make check
  make install
fi
