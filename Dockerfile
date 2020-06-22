FROM debian:8.9

WORKDIR /root

ADD . /root

RUN apt-get update && apt-get install -y python \
  supervisor \
  openssh-server \
  curl \
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
  net-tools \
  netcat \
  gnupg \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 32200 514

ENTRYPOINT ["/bin/bash","/root/entrypoint.sh"]
