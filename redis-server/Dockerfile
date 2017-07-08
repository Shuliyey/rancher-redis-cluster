FROM redis:alpine

MAINTAINER Zeyu Ye <Shuliyey@gmail.com>

RUN apk add --update curl \
  && mkdir -p /usr/local/etc/redis \
  && cd /usr/local/etc/redis \
  && wget http://download.redis.io/redis-stable/redis.conf

RUN rm -rf ~/* \
  && rm -rf /var/cache/apk/*

ADD docker-entrypoint.sh /

WORKDIR /data

EXPOSE 6379 26379

ENTRYPOINT ['/docker-entrypoint.sh']

CMD ['redis-server', '/usr/local/etc/redis/redis.conf']
