# Docker image to use.
FROM sloopstash/amazon-linux-2:v1.1.1 AS install_system_packages

# Install system packages.
RUN set -x \
  && yum install -y libcurl openssl xz-libs \
  && yum clean all \
  && rm -rf /var/cache/yum

# Intermediate Docker image to use.
FROM --platform=linux/amd64 install_system_packages AS install_mongo_db_amd64

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

# Intermediate Docker image to use.
FROM --platform=linux/arm64 install_system_packages AS install_mongo_db_arm64

# Install MongoDB.
WORKDIR /tmp
RUN set -x \
  && wget https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-amazon2-7.0.2.tgz --quiet \
  && tar xvzf mongodb-linux-aarch64-amazon2-7.0.2.tgz > /dev/null \
  && mv mongodb-linux-aarch64-amazon2-7.0.2/bin/* /usr/local/bin/ \
  && rm -rf mongodb-linux-aarch64-amazon2-7.0.2*

# Install MongoDB shell.
RUN set -x \
  && wget https://downloads.mongodb.com/compass/mongosh-2.1.5-linux-arm64.tgz --quiet \
  && tar xvzf mongosh-2.1.5-linux-arm64.tgz > /dev/null \
  && mv mongosh-2.1.5-linux-arm64/bin/* /usr/local/bin/ \
  && rm -rf mongosh-2.1.5-linux-arm64*

# Intermediate Docker image to use.
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
