#!/bin/bash

LOGFILE="/opt/redis/log/redis-cluster-init.log"

touch $LOGFILE

# Function to log messages
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

log "Starting Redis cluster initialization..."

# Wait for all Redis nodes to be ready
while ! (redis-cli -h redis-1 -p 3000 ping && \
         redis-cli -h redis-2 -p 3000 ping && \
         redis-cli -h redis-3 -p 3000 ping && \
         redis-cli -h redis-4 -p 3000 ping && \
         redis-cli -h redis-5 -p 3000 ping && \
         redis-cli -h redis-6 -p 3000 ping); do
  log "Waiting for Redis nodes to be ready..."
  sleep 5
done

log "All Redis nodes are ready. Creating cluster..."

# Create the Redis cluster
{
  yes yes | redis-cli --cluster create redis-1:3000 redis-2:3000 redis-3:3000 redis-4:3000 redis-5:3000 redis-6:3000 --cluster-replicas 1
} 2>&1 | tee -a $LOGFILE

log "Redis cluster creation complete."

# Waiting for cluster creation:
sleep 20

# Start Redis server with cluster enabled
redis-server --port 3000 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes 2>&1 | tee -a $LOGFILE

log "Redis server started with cluster enabled."

