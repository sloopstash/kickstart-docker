# Docker image to use.
FROM --platform=linux/amd64 sloopstash/alma-linux-9:v1.1.1 AS install_mongo_db_amd64

# Install system packages.
RUN yum install -y libcurl openssl xz-libs

# Install MongoDB.
WORKDIR /tmp
RUN set -x \
  && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon2-7.0.2.tgz --quiet \
  && tar xvzf mongodb-linux-x86_64-amazon2-7.0.2.tgz > /dev/null \
  && mv mongodb-linux-x86_64-amazon2-7.0.2/bin/* /usr/local/bin/ \
  && rm -rf mongodb-linux-x86_64-amazon2-7.0.2*

# Install MongoDB shell.
RUN set -x \
  && wget https://downloads.mongodb.com/compass/mongosh-2.1.5-linux-x64.tgz --quiet \
  && tar xvzf mongosh-2.1.5-linux-x64.tgz > /dev/null \
  && mv mongosh-2.1.5-linux-x64/bin/* /usr/local/bin/ \
  && rm -rf mongosh-2.1.5-linux-x64*

# Docker image to use.
FROM --platform=linux/arm64 sloopstash/alma-linux-9:v1.1.1 AS install_mongo_db_arm64

# Install system packages.
RUN yum install -y libcurl openssl xz-libs

# Install MongoDB.
WORKDIR /tmp
RUN set -x \
  && wget https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-amazon2-7.0.24.tgz --quiet \
  && tar xvzf mongodb-linux-aarch64-amazon2-7.0.24.tgz > /dev/null \
  && mv mongodb-linux-aarch64-amazon2-7.0.24/bin/* /usr/local/bin/ \
  && rm -rf mongodb-linux-aarch64-amazon2-7.0.24*

# Install MongoDB shell.
RUN set -x \
  && wget https://downloads.mongodb.com/compass/mongosh-2.5.8-linux-arm64.tgz --quiet \
  && tar xvzf mongosh-2.5.8-linux-arm64.tgz > /dev/null \
  && mv mongosh-2.5.8-linux-arm64/bin/* /usr/local/bin/ \
  && rm -rf mongosh-2.5.8-linux-arm64*

# Final Docker image setup.
FROM install_mongo_db_${TARGETARCH}

# Create MongoDB directories.
RUN set -x \
  && mkdir /opt/mongo-db \
  && mkdir /opt/mongo-db/data \
  && mkdir /opt/mongo-db/log \
  && mkdir /opt/mongo-db/conf \
  && mkdir /opt/mongo-db/script \
  && mkdir /opt/mongo-db/system \
  && touch /opt/mongo-db/system/server.pid \
  && touch /opt/mongo-db/system/supervisor.ini \
  && ln -s /opt/mongo-db/system/supervisor.ini /etc/supervisord.d/mongo-db.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/mongo-db
