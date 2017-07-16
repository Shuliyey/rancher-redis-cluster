#!/bin/bash

function leader_ip {
  echo -n $(curl -s http://rancher-metadata/latest/stacks/$1/services/$2/containers/0/primary_ip)
}

giddyup service wait scale --timeout 120
stack_name=`echo -n $(curl -s http://rancher-metadata/latest/self/stack/name)`
my_ip=`echo -n $(curl -s http://rancher-metadata/latest/self/container/primary_ip)`
master_ip=$(leader_ip $stack_name redis-server)

sed -i -E "s/^ *# *bind +.*$/bind 0.0.0.0/g" /usr/local/etc/redis/sentinel.conf
sed -i -E "s/^ *dir +.*$/dir .\//g" /usr/local/etc/redis/sentinel.conf
sed -i -E "\$s/^ *# *sentinel +announce-ip +.*$/sentinel announce-ip ${my_ip}/" /usr/local/etc/redis/sentinel.conf
sed -i -E "s/^ *sentinel +monitor +([A-z0-9._-]+) +[0-9.]+ +([0-9]+) +([0-9]+).*$/sentinel monitor \1 ${master_ip} \2 \3/g" /usr/local/etc/redis/sentinel.conf

exec docker-entrypoint.sh "$@"
