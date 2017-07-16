FROM redis

MAINTAINER Zeyu Ye <Shuliyey@gmail.com>

ARG GIDDYUP_VERSION=0.17.1

RUN apt-get update \
  && apt-get install -y curl openssl ca-certificates wget \
  && update-ca-certificates \
  && mkdir -p /usr/local/etc/redis \
  && cd /usr/local/etc/redis \
  && wget http://download.redis.io/redis-stable/sentinel.conf \
  && wget https://github.com/rancher/giddyup/releases/download/v${GIDDYUP_VERSION}/giddyup -P /usr/local/bin \
  && chmod +x /usr/local/bin/giddyup

RUN rm -rf ~/* \
  && rm -rf /var/cache/apk/*

ADD docker-entrypoint.sh /

WORKDIR /data

EXPOSE 6379 16379 26379

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["redis-server", "/usr/local/etc/redis/sentinel.conf", "--sentinel"]
