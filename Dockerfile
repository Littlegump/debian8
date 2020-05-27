FROM yinkaixuan0213/debian8_base:latest

WORKDIR /data

ADD . /data

RUN bash ./conf/script/initSoftware.sh

EXPOSE 8080 18080 2181 11080 19000

ENTRYPOINT ["/bin/bash","/root/entrypoint.sh"]
