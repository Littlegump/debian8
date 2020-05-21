FROM debian:8.9

WORKDIR /root

ADD . /root

RUN apt-get update && apt-get install -y python \
  supervisor \
  openssh-server \
  libpcre3-dev \
  libz-dev \
  autoconf \
  openssl \
  curl \
  libtool \
  tcpdump \
  vim \
  libssl-dev \
  psmisc \
  wget \
  man-db \
  apt-transport-https \
  python-pip \
  git \
  gcc \
  make \
  flex \
  hwloc \
  lua5.2 \
  net-tools \
  netcat \
  gnupg \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN /bin/bash install_ats.sh

ENTRYPOINT ["/bin/bash","/root/entrypoint.sh"]
