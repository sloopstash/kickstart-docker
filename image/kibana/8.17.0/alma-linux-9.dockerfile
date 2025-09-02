# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install system packages.
RUN set -x \
  && dnf install -y perl-Digest-SHA \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install Kibana.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/kibana/kibana-8.17.0-linux-x86_64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/kibana/kibana-8.17.0-linux-x86_64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c kibana-8.17.0-linux-x86_64.tar.gz.sha512 \
  && tar xvzf kibana-8.17.0-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/kibana \
  && cp -r kibana-8.17.0/* /usr/local/lib/kibana/ \
  && rm -rf kibana-8.17.0*

# Create Kibana directories.
RUN set -x \
  && mkdir /opt/kibana \
  && mkdir /opt/kibana/data \
  && mkdir /opt/kibana/log \
  && mkdir /opt/kibana/conf \
  && mkdir /opt/kibana/script \
  && mkdir /opt/kibana/system \
  && touch /opt/kibana/system/server.pid \
  && touch /opt/kibana/system/supervisor.ini \
  && ln -s /opt/kibana/system/supervisor.ini /etc/supervisord.d/kibana.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/kibana
