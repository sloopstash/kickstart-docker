# Docker image to use.
FROM --platform=linux/amd64 sloopstash/alma-linux-9:v1.1.1 AS install_prometheus_amd64

# Install Prometheus.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/prometheus/prometheus/releases/download/v3.8.1/prometheus-3.8.1.linux-amd64.tar.gz --quiet \
  && tar xvzf prometheus-3.8.1.linux-amd64.tar.gz > /dev/null \
  && mv prometheus-3.8.1.linux-amd64/prometheus /usr/local/bin/ \
  && mv prometheus-3.8.1.linux-amd64/promtool /usr/local/bin/ \
  && rm -rf prometheus-3.8.1.linux-amd64*

# Docker image to use.
FROM --platform=linux/arm64 sloopstash/alma-linux-9:v1.1.1 AS install_prometheus_arm64

# Install Prometheus.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/prometheus/prometheus/releases/download/v3.8.1/prometheus-3.8.1.darwin-arm64.tar.gz --quiet \
  && tar xvzf prometheus-3.8.1.darwin-arm64.tar.gz > /dev/null \
  && mv prometheus-3.8.1.darwin-arm64/prometheus /usr/local/bin/ \
  && mv prometheus-3.8.1.darwin-arm64/promtool /usr/local/bin/ \
  && rm -rf prometheus-3.8.1.darwin-arm64*

# Intermediate Docker image to use.
FROM install_prometheus_${TARGETARCH}

# Create Prometheus directories.
RUN set -x \
  && mkdir /opt/prometheus \
  && mkdir /opt/prometheus/data \
  && mkdir /opt/prometheus/log \
  && mkdir /opt/prometheus/conf \
  && mkdir /opt/prometheus/script \
  && mkdir /opt/prometheus/system \
  && touch /opt/prometheus/system/server.pid \
  && touch /opt/prometheus/system/supervisor.ini \
  && ln -s /opt/prometheus/system/supervisor.ini /etc/supervisord.d/prometheus.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/prometheus
