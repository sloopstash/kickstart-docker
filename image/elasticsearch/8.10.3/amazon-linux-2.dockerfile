# Docker image to use.
FROM sloopstash/base:v1.1.1

# Create system user for Elasticsearch.
RUN set -x \
  && useradd -m -s /bin/bash -d /usr/local/lib/elasticsearch elasticsearch

# Download and extract ElasticSearch .
COPY elasticsearch-8.10.3-linux-x86_64.tar.gz ./
RUN set -x \
  && tar xzf elasticsearch-8.10.3-linux-x86_64.tar.gz > /dev/null \
  && cp -r elasticsearch-8.10.3/* /usr/local/lib/elasticsearch/ \
  && chown -R elasticsearch:elasticsearch /usr/local/lib/elasticsearch \
  && rm -rf elasticsearch-8.10.3*

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
