# Docker image to use.
FROM sloopstash/amazon-linux-2:v1.1.1

# Install Oracle JDK.
WORKDIR /tmp
COPY jdk-8u131-linux-x64.rpm ./
RUN set -x \
  && yum install -y jdk-8u131-linux-x64.rpm \
  && rm -f jdk-8u131-linux-x64.rpm

# Install Elasticsearch.
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.2.tar.gz --quiet \
  && tar xvzf elasticsearch-6.8.2.tar.gz > /dev/null \
  && mkdir /usr/local/lib/elasticsearch \
  && cp -r elasticsearch-6.8.2/* /usr/local/lib/elasticsearch/ \
  && rm -rf elasticsearch-6.8.2*

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
