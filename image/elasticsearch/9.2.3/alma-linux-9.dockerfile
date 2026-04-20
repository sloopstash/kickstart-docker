# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1 AS install_system_packages

# Install system packages.
RUN set -x \
  && dnf install -y perl-Digest-SHA \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Intermediate Docker image to use.
FROM --platform=linux/amd64 install_system_packages AS install_elasticsearch_amd64

# Install Elasticsearch.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.2.3-linux-x86_64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.2.3-linux-x86_64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c elasticsearch-9.2.3-linux-x86_64.tar.gz.sha512 \
  && tar -xzf elasticsearch-9.2.3-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/elasticsearch \
  && cp -r elasticsearch-9.2.3/* /usr/local/lib/elasticsearch/ \
  && rm -rf elasticsearch-9.2.3*

# Intermediate Docker image to use.
FROM --platform=linux/arm64 install_system_packages AS install_elasticsearch_arm64

# Install Elasticsearch.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.2.3-linux-aarch64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.2.3-linux-aarch64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c elasticsearch-9.2.3-linux-aarch64.tar.gz.sha512 \
  && tar xvzf elasticsearch-9.2.3-linux-aarch64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/elasticsearch \
  && cp -r elasticsearch-9.2.3/* /usr/local/lib/elasticsearch/ \
  && rm -rf elasticsearch-9.2.3*

# Intermediate Docker image to use.
FROM install_elasticsearch_${TARGETARCH}

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