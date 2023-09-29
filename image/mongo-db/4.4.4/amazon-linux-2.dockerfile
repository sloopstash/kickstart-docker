# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y libcurl openssl xz-libs

# Switch work directory.
WORKDIR /tmp

# Download, extract, and install MongoDB.
RUN set -x \
  && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon2-4.4.4.tgz --quiet \
  && tar xvzf mongodb-linux-x86_64-amazon2-4.4.4.tgz > /dev/null \
  && cp -r mongodb-linux-x86_64-amazon2-4.4.4/bin/* /usr/local/bin/ \
  && rm -rf mongodb-linux-x86_64-amazon2-4.4.4*

# Create MongoDB directories.
RUN set -x \
  && mkdir /opt/mongo-db \
  && mkdir /opt/mongo-db/data \
  && mkdir /opt/mongo-db/log \
  && mkdir /opt/mongo-db/conf \
  && history -c

# Set default work directory.
WORKDIR /opt/mongo-db
