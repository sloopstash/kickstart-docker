
#!/bin/bash
set -e

# Wait until MongoDB is available
until mongo --eval "print(\"waited for connection\")" > /dev/null 2>&1; do
  echo "Waiting for MongoDB to be available..."
  sleep 5
done

# Initialize the replica set
mongo --eval "rs.initiate({
  \"_id\": \"main\",
  \"members\": [
    { \"_id\": 1, \"host\": \"mongo-db-1:7000\" },
    { \"_id\": 2, \"host\": \"mongo-db-2:7000\" },
    { \"_id\": 3, \"host\": \"mongo-db-3:7000\" }
  ]
})"
