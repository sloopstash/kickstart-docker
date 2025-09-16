# Docker image to use.
FROM --platform=linux/amd64 sloopstash/alma-linux-9:v1.1.1 AS install_logstash_amd64

# Install system packages.
RUN set -x \
  && dnf install -y perl-Digest-SHA \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install Logstash.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.17.0-linux-x86_64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.17.0-linux-x86_64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c logstash-8.17.0-linux-x86_64.tar.gz.sha512 \
  && tar xvzf logstash-8.17.0-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/logstash \
  && cp -r logstash-8.17.0/* /usr/local/lib/logstash/ \
  && rm -rf logstash-8.17.0*

# Docker image to use.
FROM --platform=linux/arm64 sloopstash/alma-linux-9:v1.1.1 AS install_logstash_arm64

# Install system packages.
RUN set -x \
  && dnf install -y perl-Digest-SHA \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install Logstash.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.17.0-linux-aarch64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.17.0-linux-aarch64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c logstash-8.17.0-linux-aarch64.tar.gz.sha512 \
  && tar xvzf logstash-8.17.0-linux-aarch64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/logstash \
  && cp -r logstash-8.17.0/* /usr/local/lib/logstash/ \
  && rm -rf logstash-8.17.0*

# Final Docker image setup.
FROM install_logstash_${TARGETARCH}

# Create Logstash directories.
RUN set -x \
  && mkdir /opt/logstash \
  && mkdir /opt/logstash/data \
  && mkdir /opt/logstash/log \
  && mkdir /opt/logstash/conf \
  && mkdir /opt/logstash/script \
  && mkdir /opt/logstash/system \
  && touch /opt/logstash/system/server.pid \
  && touch /opt/logstash/system/supervisor.ini \
  && ln -sf /opt/logstash/conf/server.yml /usr/local/lib/logstash/config/logstash.yml \
  && ln -sf /opt/logstash/conf/jvm.options /usr/local/lib/logstash/config/jvm.options \
  && ln -sf /opt/logstash/conf/pipelines.yml /usr/local/lib/logstash/config/pipelines.yml \
  && ln -s /opt/logstash/system/supervisor.ini /etc/supervisord.d/logstash.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/logstash
