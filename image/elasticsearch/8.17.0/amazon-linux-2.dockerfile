# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y perl-Digest-SHA

# Install Elasticsearch.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.0-linux-x86_64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.0-linux-x86_64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c elasticsearch-8.17.0-linux-x86_64.tar.gz.sha512 \
  && tar xvzf elasticsearch-8.17.0-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/elasticsearch \
  && cp -r elasticsearch-8.17.0/* /usr/local/lib/elasticsearch/ \
  && rm -rf elasticsearch-8.17.0*

# Create Elasticsearch directories.
RUN set -x \
  && mkdir /opt/elasticsearch \
  && mkdir /opt/elasticsearch/data \
  && mkdir /opt/elasticsearch/log \
  && mkdir /opt/elasticsearch/conf \
  && mkdir /opt/elasticsearch/script \
  && mkdir /opt/elasticsearch/system \
  && touch /opt/elasticsearch/system/node.pid \
  && touch /opt/elasticsearch/system/supervisor.ini \
  && ln -s /opt/elasticsearch/system/supervisor.ini /etc/supervisord.d/elasticsearch.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/elasticsearch
