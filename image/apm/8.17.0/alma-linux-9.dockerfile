# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install system packages.
RUN set -x \
  && dnf install -y perl-Digest-SHA \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install APM.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/apm-server/apm-server-8.17.0-linux-x86_64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/apm-server/apm-server-8.17.0-linux-x86_64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c apm-server-8.17.0-linux-x86_64.tar.gz.sha512 \
  && tar xvzf apm-server-8.17.0-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/apm \
  && cp -r apm-server-8.17.0/* /usr/local/lib/apm/ \
  && rm -rf apm-server-8.17.0*

# Create APM directories.
RUN set -x \
  && mkdir /opt/apm \
  && mkdir /opt/apm/data \
  && mkdir /opt/apm/log \
  && mkdir /opt/apm/conf \
  && mkdir /opt/apm/script \
  && mkdir /opt/apm/system \
  && touch /opt/apm/system/server.pid \
  && touch /opt/apm/system/supervisor.ini \
  && ln -sf /opt/apm/conf/server.yml /usr/local/lib/apm/apm-server.yml \
  && ln -s /opt/apm/system/supervisor.ini /etc/supervisord.d/apm.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/apm
