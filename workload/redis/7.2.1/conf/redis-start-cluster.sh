#!/bin/bash

LOGFILE="/opt/redis/log/redis-cluster-init.log"

touch $LOGFILE

# Function to log messages
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

log "Starting Redis cluster initialization..."

# Wait for all Redis nodes to be ready
while ! (redis-cli -h 16.1.1.2 -p 3000 ping && \
         redis-cli -h 16.1.1.3 -p 3000 ping && \
         redis-cli -h 16.1.1.4 -p 3000 ping && \
         redis-cli -h 16.1.1.5 -p 3000 ping && \
         redis-cli -h 16.1.1.6 -p 3000 ping && \
         redis-cli -h 16.1.1.7 -p 3000 ping); do
  log "Waiting for Redis nodes to be ready..."
  sleep 5
done

log "All Redis nodes are ready. Creating cluster..."

# Create the Redis cluster
{
  yes yes | redis-cli --cluster create 16.1.1.2:3000 16.1.1.3:3000 16.1.1.4:3000 16.1.1.5:3000 16.1.1.6:3000 16.1.1.7:3000 --cluster-replicas 1
} 2>&1 | tee -a $LOGFILE

log "Redis cluster creation complete."

# Waiting for cluster creation:
sleep 20

# Start Redis server with cluster enabled
redis-server --port 3000 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes 2>&1 | tee -a $LOGFILE

log "Redis server started with cluster enabled."
