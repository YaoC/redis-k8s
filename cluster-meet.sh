#!/bin/bash
echo "pod name: ${POD_NAME}"
echo "redis port: ${PORT}"
set -e

# Port on which redis listens for connections.
CLUSTER_IPS=""

if [[ $(echo ${POD_NAME} | cut -d'-' -s -f2) == 5 ]]; then
  echo "creating cluster..."
  # Convert all peers to raw addresses
  while read -ra LINE; do
    CLUSTER_IPS="${CLUSTER_IPS} ${LINE}:${PORT}"
  done
  echo ${CLUSTER_IPS}

  # Wait until local redis is available before proceeding
  until redis-cli -p ${PORT} ping; do sleep 1; done

  # redis-trib.rb should only run once, and should only call yes_or_die once
  # during init. Not wild about possible unintended confirmations...
  echo yes | /usr/local/bin/redis-trib.rb create --replicas 1 ${CLUSTER_IPS}
elif [[ $(echo ${POD_NAME} | cut -d'-' -s -f2) -gt 5 ]]; then
  echo "meeting cluster..."
  getent hosts redis-0.redis.default.svc.cluster.local
  /usr/local/bin/redis-trib.rb add-node --slave $(getent hosts ${POD_NAME} | cut -d' ' -f1):${PORT} $(getent hosts redis-0.redis.default.svc.cluster.local | cut -d' ' -f1):${PORT}
else
  echo "cluster too small"
fi