# Docker image to use.
FROM sloopstash/base-ubuntu-22-04:v1.1.1

# Install system packages.
RUN set -x \
&& apt-get update \
&& apt-get install libcurl4 libgssapi-krb5-2 libldap-2.5-0 libwrap0 libsasl2-2 libsasl2-modules libsasl2-modules-gssapi-mit openssl liblzma5

# Switch work directory.
WORKDIR /tmp

# Download, extract, and install MongoDB.
RUN set -x \
  && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.2.tgz --quiet \
  && tar -zxvf mongodb-linux-x86_64-ubuntu2204-7.0.2.tgz > /dev/null \
  && cp -r mongodb-linux-x86_64-ubuntu2204-7.0.2/bin/* /usr/local/bin/ \
  && rm -rf mongodb-linux-x86_64-ubuntu2204-7.0.2*

# Create MongoDB directories.
RUN set -x \
  && mkdir /opt/mongo-db \
  && mkdir /opt/mongo-db/data \
  && mkdir /opt/mongo-db/log \
  && mkdir /opt/mongo-db/conf \
  && history -c

# Set default work directory.
WORKDIR /opt/mongo-db
