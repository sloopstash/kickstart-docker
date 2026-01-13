# Docker image to use.
FROM --platform=linux/amd64 sloopstash/alma-linux-9:v1.1.1 AS install_grafana_amd64

# Install Grafana.
WORKDIR /tmp
RUN set -x \
  && wget https://dl.grafana.com/grafana/release/12.3.0/grafana_12.3.0_19497075765_linux_amd64.tar.gz --quiet \
  && tar xvzf grafana_12.3.0_19497075765_linux_amd64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/grafana \
  && cp -r grafana-12.3.0/* /usr/local/lib/grafana/ \
  && rm -rf grafana-12.3.0*

# Docker image to use.
FROM --platform=linux/arm64 sloopstash/alma-linux-9:v1.1.1 AS install_grafana_arm64

# Install Grafana.
WORKDIR /tmp
RUN set -x \
  && wget https://dl.grafana.com/grafana/release/12.3.0/grafana_12.3.0_19497075765_linux_arm64.tar.gz --quiet \
  && tar xvzf grafana_12.3.0_19497075765_linux_arm64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/grafana \
  && cp -r grafana-12.3.0/* /usr/local/lib/grafana/ \
  && rm -rf grafana-12.3.0*

# Intermediate Docker image to use.
FROM install_grafana_${TARGETARCH}

# Create Grafana directories.
RUN set -x \
  && mkdir /opt/grafana \
  && mkdir /opt/grafana/plugin \
  && mkdir /opt/grafana/provisioning \
  && mkdir /opt/grafana/data \
  && mkdir /opt/grafana/log \
  && mkdir /opt/grafana/conf \
  && mkdir /opt/grafana/script \
  && mkdir /opt/grafana/system \
  && touch /opt/grafana/system/server.pid \
  && touch /opt/grafana/system/supervisor.ini \
  && ln -s /opt/grafana/system/supervisor.ini /etc/supervisord.d/grafana.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/grafana
