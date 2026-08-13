# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1 AS install_system_packages

# Install system packages.
RUN set -x \
  && dnf install -y zstd \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Intermediate Docker image to use.
FROM --platform=linux/amd64 install_system_packages AS install_ollama_amd64

# Install Ollama.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/ollama/ollama/releases/download/v0.32.5/ollama-linux-amd64.tar.zst --quiet \
  && tar --zstd -xvf ollama-linux-amd64.tar.zst > /dev/null \
  && mkdir /usr/local/lib/ollama \
  && cp -r lib/ollama/* /usr/local/lib/ollama/ \
  && mv bin/ollama /usr/local/bin/ \
  && rm -rf ollama* lib bin
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/opt/ollama/model

# Intermediate Docker image to use.
FROM --platform=linux/arm64 install_system_packages AS install_ollama_arm64

# Install Ollama.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/ollama/ollama/releases/download/v0.32.5/ollama-linux-arm64.tar.zst --quiet \
  && tar --zstd -xvf ollama-linux-arm64.tar.zst > /dev/null \
  && mkdir /usr/local/lib/ollama \
  && cp -r lib/ollama/* /usr/local/lib/ollama/ \
  && mv bin/ollama /usr/local/bin/ \
  && rm -rf ollama* lib bin
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/opt/ollama/model

# Intermediate Docker image to use.
FROM install_ollama_${TARGETARCH}

# Create Ollama directories.
RUN set -x \
  && mkdir /opt/ollama \
  && mkdir /opt/ollama/model \
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
