# Docker image to use.
FROM sloopstash/node-js:v24.17.0

# Install system packages.
RUN set -x \
  && dnf install -y gcc-c++ fuse-libs \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Download Xen Orchestra.
RUN git clone -b master https://github.com/vatesfr/xen-orchestra.git /usr/local/lib/xen-orchestra

# Install Xen Orchestra.
WORKDIR /usr/local/lib/xen-orchestra
RUN set -x \
  && yarn \
  && yarn build \
  && mkdir /etc/xo-server \
  && yarn cache clean

# Create Xen Orchestra directories.
RUN set -x \
  && mkdir /opt/xen-orchestra \
  && mkdir /opt/xen-orchestra/data \
  && mkdir /opt/xen-orchestra/log \
  && mkdir /opt/xen-orchestra/conf \
  && mkdir /opt/xen-orchestra/script \
  && mkdir /opt/xen-orchestra/system \
  && touch /opt/xen-orchestra/system/server.pid \
  && touch /opt/xen-orchestra/system/supervisor.ini \
  && ln -sf /opt/xen-orchestra/conf/server.toml /etc/xo-server/config.toml \
  && ln -s /opt/xen-orchestra/system/supervisor.ini /etc/supervisord.d/xen-orchestra.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/xen-orchestra
