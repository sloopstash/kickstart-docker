# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Download and extract Prometheus.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/prometheus/prometheus/releases/download/v3.8.1/prometheus-3.8.1.linux-amd64.tar.gz --quiet \
  && tar xvzf prometheus-3.8.1.linux-amd64.tar.gz > /dev/null \
  && cd prometheus-3.8.1.linux-amd64 \
  && mkdir /usr/local/lib/prometheus/ \
  && cp prometheus /usr/local/lib/prometheus/ \
  && cp promtool /usr/local/lib/prometheus/  

# Create system user for prometheus.
RUN useradd -m prometheus

# Create Prometheus directories.
RUN set -x \
  && mkdir /opt/prometheus \
  && mkdir /opt/prometheus/data \
  && mkdir /opt/prometheus/log \
  && mkdir /opt/prometheus/conf \
  && mkdir /opt/prometheus/script \
  && mkdir /opt/prometheus/system \
  && mkdir -p /etc/supervisord.d \
  && touch /opt/prometheus/system/server.pid \
  && touch /opt/prometheus/system/supervisor.ini \
  && ln -s /opt/prometheus/system/supervisor.ini /etc/supervisord.d/prometheus.ini \
  && chown -R prometheus:prometheus /opt/prometheus \
  && rm -rf prometheus-3.8.1.linux-amd64* \
  && history -c

# Set default work directory.
WORKDIR /opt/prometheus