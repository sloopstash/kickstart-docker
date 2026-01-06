# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install Grafana.
WORKDIR /tmp
RUN set -x \
  && wget https://dl.grafana.com/grafana/release/12.3.0/grafana_12.3.0_19497075765_linux_amd64.tar.gz --quiet \
  && tar xvzf grafana_12.3.0_19497075765_linux_amd64.tar.gz > /dev/null \
  && mkdir /usr/local/bin/grafana \
  && cp -r grafana-12.3.0 /usr/local/bin/grafana \
  && rm -rf grafana-12.3.0

# Create system user for Grafana
RUN set -x \
  && useradd -r -s /bin/false grafana \
  && chown -R grafana:users /usr/local/bin/grafana

# Create Grafana directories.
RUN set -x \
  && mkdir /opt/grafana \
  && mkdir /opt/grafana/data \
  && mkdir /opt/grafana/log \
  && mkdir /opt/grafana/conf \
  && mkdir /opt/grafana/script \
  && mkdir /opt/grafana/system \
  && mkdir /opt/grafana/conf/provisioning \
  && mkdir /opt/grafana/plugins \
  && touch /opt/grafana/system/server.pid \
  && touch /opt/grafana/system/supervisor.ini \
  && ln -s /opt/grafana/system/supervisor.ini /etc/supervisord.d/grafana.ini\
  && cp -r conf/* /opt/grafana/conf/provisioning \
  && chown -R grafana:users /opt/grafana \
  && history -c

# Set default work directory.
WORKDIR /opt/grafana