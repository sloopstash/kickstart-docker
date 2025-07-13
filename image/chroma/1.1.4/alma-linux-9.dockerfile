# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install Chroma.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/chroma-core/chroma/releases/download/cli-1.1.4/chroma-linux --quiet \
  && mv chroma-linux /usr/local/bin/chroma \
  && chmod +x /usr/local/bin/chroma

# Create Chroma directories.
RUN set -x \
  && mkdir /opt/chroma \
  && mkdir /opt/chroma/data \
  && mkdir /opt/chroma/log \
  && mkdir /opt/chroma/conf \
  && mkdir /opt/chroma/script \
  && mkdir /opt/chroma/system \
  && touch /opt/chroma/system/server.pid \
  && touch /opt/chroma/system/supervisor.ini \
  && ln -s /opt/chroma/system/supervisor.ini /etc/supervisord.d/chroma.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/chroma
