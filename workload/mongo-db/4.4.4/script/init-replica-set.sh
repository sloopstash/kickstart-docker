
#!/bin/bash
set -e

# Wait until MongoDB is available
until mongo --eval "print(\"waited for connection\")" > /dev/null 2>&1; do
  echo "Waiting for MongoDB to be available..."
  sleep 5
done

# Initialize the replica set
mongo --eval "rs.initiate({
  \"_id\": \"replica_cluster\",
  \"members\": [
    { \"_id\": 0, \"host\": \"mongo-db-node-1:27017\" },
    { \"_id\": 1, \"host\": \"mongo-db-node-2:27017\" },
    { \"_id\": 2, \"host\": \"mongo-db-node-3:27017\" }
  ]
})"
