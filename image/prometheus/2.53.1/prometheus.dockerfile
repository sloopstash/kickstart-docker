# Docker image to use
From sloopstash/base:v1.1.1

# Download and extract Prometheus
WORKDIR /tmp
RUN set -x \
    && wget https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz --quiet \
    && tar -xvzf prometheus-2.53.1.linux-amd64.tar.gz > /dev/null

# Compile and install Prometheus
WORKDIR prometheus-2.53.1.linux-amd64
RUN set -x \
    && cp prometheus /usr/local/bin/ \
    && cp promtool /usr/local/bin/

# Create Prometheus directories.
RUN set -x \
  && mkdir /opt/prometheus \
  && mkdir /opt/prometheus/data \
  && mkdir /opt/prometheus/log \
  && mkdir /opt/prometheus/conf \
  && mkdir /opt/prometheus/script \
  && mkdir /opt/prometheus/system \
  && mkdir /opt/prometheus/console_libraries \
  && mkdir /opt/prometheus/consoles \
  && touch /opt/prometheus/system/server.pid \
  && touch /opt/prometheus/system/supervisor.ini \
  && ln -s /opt/prometheus/system/supervisor.ini /etc/supervisord.d/prometheus.ini \
  && cp -r consoles/* /opt/prometheus/consoles \
  && cp -r console_libraries/* /opt/prometheus/console_libraries \
  && cd ../ \
  && rm -rf prometheus-2.53.1.linux* \
  && history -c

# Set default work directory.
WORKDIR /opt/prometheus