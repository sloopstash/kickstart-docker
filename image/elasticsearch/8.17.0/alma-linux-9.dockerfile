# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install system packages.
RUN set -x \
  && dnf install -y perl-Digest-SHA \
  && dnf clean all \
  && rm -rf /var/cache/dnf

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

# Create system user for Elasticsearch.
RUN useradd -m elasticsearch

# Create Elasticsearch directories.
RUN set -x \
  && mkdir /opt/elasticsearch \
  && mkdir /opt/elasticsearch/data \
  && mkdir /opt/elasticsearch/log \
  && mkdir /opt/elasticsearch/conf \
  && mkdir /opt/elasticsearch/script \
  && mkdir /opt/elasticsearch/system \
  && touch /opt/elasticsearch/system/server.pid \
  && touch /opt/elasticsearch/system/supervisor.ini \
  && ln -sf /opt/elasticsearch/conf/server.yml /usr/local/lib/elasticsearch/config/elasticsearch.yml \
  && ln -sf /opt/elasticsearch/conf/jvm.options /usr/local/lib/elasticsearch/config/jvm.options \
  && ln -s /opt/elasticsearch/system/security-limit.conf /etc/security/limits.d/elasticsearch.conf \
  && ln -s /opt/elasticsearch/system/supervisor.ini /etc/supervisord.d/elasticsearch.ini \
  && chown -R elasticsearch:elasticsearch /usr/local/lib/elasticsearch \
  && chown -R elasticsearch:elasticsearch /opt/elasticsearch \
  && history -c

# Set default work directory.
WORKDIR /opt/elasticsearch
