# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install system packages.
RUN set -x \
  && dnf install -y curl wget gawk grep sed coreutils --allowerasing \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install Ollama.
WORKDIR /tmp
RUN set -x \
  && wget https://ollama.com/download/ollama-linux-amd64.tgz -O ollama-linux-amd64.tgz \
  && tar -xzf ollama-linux-amd64.tgz > /dev/null \
  && cp bin/ollama /usr/local/bin/ollama \
  && chmod 755 /usr/local/bin/ollama \
  && rm -rf bin ollama-linux-amd64* \
  && rm -rf /var/cache/dnf

# Create log directories.
RUN set -x \
  && mkdir -p /opt/ollama \
  && mkdir /opt/ollama/data \
  && mkdir /opt/ollama/log \
  && mkdir /opt/ollama/conf \
  && mkdir /opt/ollama/script \
  && mkdir /opt/ollama/system \
  && touch /opt/ollama/system/server.pid \
  && touch /opt/ollama/system/supervisor.ini \
  && ln -s /opt/ollama/system/supervisor.ini /etc/supervisord.d/ollama.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/ollama