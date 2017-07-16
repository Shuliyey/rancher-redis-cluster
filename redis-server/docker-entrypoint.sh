#!/bin/bash

function leader_ip {
  echo -n $(curl -s http://rancher-metadata/latest/stacks/$1/services/$2/containers/0/primary_ip)
}

giddyup service wait scale --timeout 120
stack_name=`echo -n $(curl -s http://rancher-metadata/latest/self/stack/name)`
my_ip=`echo -n $(curl -s http://rancher-metadata/latest/self/container/primary_ip)`
master_ip=$(leader_ip $stack_name redis-server)

sed -i -E "s/^ *bind +.*$/bind 0.0.0.0/g" /usr/local/etc/redis/redis.conf
sed -i -E "s/^ *# +cluster-enabled +.*$/cluster-enabled yes/g" /usr/local/etc/redis/redis.conf
sed -i -E "s/^ *# +cluster-config-file +(.*)$/cluster-config-file \1/g" /usr/local/etc/redis/redis.conf
sed -i -E "s/^ *# +cluster-node-timeout +(.*)$/cluster-node-timeout \1/g" /usr/local/etc/redis/redis.conf
sed -i -E "s/^ *appendonly +.*$/appendonly yes/g" /usr/local/etc/redis/redis.conf

if [ "$my_ip" == "$master_ip" ]
then
  echo "i am the leader"
else
  port=`echo -n $(grep -E "^ *port +.*$" /usr/local/etc/redis/redis.conf | sed -E "s/^ *port +(.*)$/\1/g")`
  sed -i -E "s/^ *# +slaveof +.*$/slaveof $master_ip $port/g" /usr/local/etc/redis/redis.conf
fi

exec docker-entrypoint.sh "$@"
