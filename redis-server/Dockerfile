FROM redis:alpine

MAINTAINER Zeyu Ye <Shuliyey@gmail.com>

ARG GIDDYUP_VERSION=0.17.1

RUN apk add --update curl openssl ca-certificates \
  && update-ca-certificates \
  && mkdir -p /usr/local/etc/redis \
  && cd /usr/local/etc/redis \
  && wget http://download.redis.io/redis-stable/redis.conf \
  && wget https://github.com/rancher/giddyup/releases/download/v${GIDDYUP_VERSION}/giddyup -P /usr/local/bin \
  && chmod +x /usr/local/bin/giddyup

RUN rm -rf ~/* \
  && rm -rf /var/cache/apk/*

ADD docker-entrypoint.sh /

WORKDIR /data

EXPOSE 6379 26379

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
