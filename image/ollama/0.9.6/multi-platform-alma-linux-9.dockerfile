# Docker image to use.
FROM --platform=linux/amd64 sloopstash/alma-linux-9:v1.1.1 AS install_ollama_amd64

# Install Ollama.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/ollama/ollama/releases/download/v0.9.6/ollama-linux-amd64.tgz --quiet \
  && tar xvzf ollama-linux-amd64.tgz > /dev/null \
  && mkdir /usr/local/lib/ollama \
  && cp -r lib/ollama/* /usr/local/lib/ollama/ \
  && mv bin/ollama /usr/local/bin/ \
  && rm -rf ollama* lib bin
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/opt/ollama/model

# Docker image to use.
FROM --platform=linux/arm64 sloopstash/alma-linux-9:v1.1.1 AS install_ollama_arm64

# Install Ollama.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/ollama/ollama/releases/download/v0.9.6/ollama-linux-arm64.tgz  --quiet \
  && tar xvzf ollama-linux-arm64.tgz > /dev/null \
  && mkdir /usr/local/lib/ollama \
  && cp -r lib/ollama/* /usr/local/lib/ollama/ \
  && mv bin/ollama /usr/local/bin/ \
  && rm -rf ollama* lib bin
ENV OLLAMA_HOST=0.0.0.0 
ENV OLLAMA_MODELS=/opt/ollama/model

# Final Docker image setup.
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
