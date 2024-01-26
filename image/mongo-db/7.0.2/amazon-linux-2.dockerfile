# Docker image to use.
FROM sloopstash/base-amazon-linux-2:v1.1.1

# Switch work directory.
WORKDIR /tmp

# Download, extract, and install MongoDB.
RUN set -x \
  && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon2-7.0.2.tgz --quiet \
  && tar xvzf mongodb-linux-x86_64-amazon2-7.0.2.tgz > /dev/null \
  && cp -r mongodb-linux-x86_64-amazon2-7.0.2/bin/* /usr/local/bin/ \
  && rm -rf mongodb-linux-x86_64-amazon2-7.0.2*

# Create MongoDB directories.
RUN set -x \
  && mkdir /opt/mongo-db \
  && mkdir /opt/mongo-db/data \
  && mkdir /opt/mongo-db/log \
  && mkdir /opt/mongo-db/conf \
  && history -c

# Set default work directory.
WORKDIR /opt/mongo-db
