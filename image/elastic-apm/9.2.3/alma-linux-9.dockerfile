# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1 AS install_system_packages

# Install system packages.
RUN set -x \
  && dnf install -y perl-Digest-SHA \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Intermediate Docker image to use.
FROM --platform=linux/amd64 install_system_packages AS install_elastic_apm_amd64

# Install Elastic APM.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/apm-server/apm-server-9.2.3-linux-x86_64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/apm-server/apm-server-9.2.3-linux-x86_64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c apm-server-9.2.3-linux-x86_64.tar.gz.sha512 \
  && tar xvzf apm-server-9.2.3-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/elastic-apm \
  && cp -r apm-server-9.2.3-linux-x86_64/* /usr/local/lib/elastic-apm/ \
  && rm -rf apm-server-9.2.3*

# Intermediate Docker image to use.
FROM --platform=linux/arm64 install_system_packages AS install_elastic_apm_arm64

# Install Elastic APM.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/apm-server/apm-server-9.2.3-linux-arm64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/apm-server/apm-server-9.2.3-linux-arm64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c apm-server-9.2.3-linux-arm64.tar.gz.sha512 \
  && tar xvzf apm-server-9.2.3-linux-arm64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/elastic-apm \
  && cp -r apm-server-9.2.3-linux-arm64/* /usr/local/lib/elastic-apm/ \
  && rm -rf apm-server-9.2.3*

# Intermediate Docker image to use.
FROM install_elastic_apm_${TARGETARCH}

# Create Elastic APM directories.
RUN set -x \
  && mkdir /opt/elastic-apm \
  && mkdir /opt/elastic-apm/data \
  && mkdir /opt/elastic-apm/log \
  && mkdir /opt/elastic-apm/conf \
  && mkdir /opt/elastic-apm/script \
  && mkdir /opt/elastic-apm/system \
  && touch /opt/elastic-apm/system/server.pid \
  && touch /opt/elastic-apm/system/supervisor.ini \
  && ln -sf /opt/elastic-apm/conf/server.yml /usr/local/lib/elastic-apm/apm-server.yml \
  && ln -s /opt/elastic-apm/system/supervisor.ini /etc/supervisord.d/elastic-apm.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/elastic-apm
