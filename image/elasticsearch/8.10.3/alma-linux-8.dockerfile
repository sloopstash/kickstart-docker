# Docker image to use.
FROM sloopstash/base-alma-linux-8:v1.1.1

# Create system user for Elasticsearch.
RUN set -x \
  && useradd -m -s /bin/bash -d /usr/local/lib/elasticsearch elasticsearch

# Switch work directory.
WORKDIR /tmp

# Download, extract, and install Elastic search.
COPY ["elasticsearch-8.10.3-linux-x86_64.tar.gz", "elasticsearch-8.10.3-linux-x86_64.tar.gz.sha512", "./"]
RUN set -x \
  && sha512sum -c elasticsearch-8.10.3-linux-x86_64.tar.gz.sha512 \
  && tar -xzf elasticsearch-8.10.3-linux-x86_64.tar.gz > /dev/null \
  && rm -rf elasticsearch-8.10.3-linux-x86_64.tar.gz \
  && rm -rf elasticsearch-8.10.3-linux-x86_64.tar.gz.sha512*

# Create Elasticsearch directories.
RUN set -x \
  && mkdir /opt/elasticsearch \
  && mkdir /opt/elasticsearch/data \
  && mkdir /opt/elasticsearch/log \
  && mkdir /opt/elasticsearch/system \
  && touch /opt/elasticsearch/system/process.pid \
  && chown -R elasticsearch:elasticsearch /opt/elasticsearch \
  && history -c

# Set default work directory.
WORKDIR /opt/elasticsearch
