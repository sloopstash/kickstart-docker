#!/bin/bash

function wait_for_redis_node() {
  local node=$1;
  until redis-cli -h $node -p 3000 ping > /dev/null 2>&1; do
    printf "Waiting for $node...\n";
    sleep 5;
  done;
  printf "$node is ready.\n";
}

function create_redis_cluster() {
  yes yes | redis-cli --cluster create redis-{1..6}:3000 --cluster-replicas 1;
  printf "Redis cluster started.\n";
}

printf "Starting Redis cluster initialization...\n";

for node in redis-{1..6}; do
  wait_for_redis_node $node;
done;

create_redis_cluster;
