# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install system packages.
RUN set -x \
  && dnf install -y jq \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install NVM, NodeJS, and Yarn.
ENV NVM_DIR=/usr/local/lib/nvm
RUN set -x \
  && mkdir /usr/local/lib/nvm \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash \
  && \. "$NVM_DIR/nvm.sh" \
  && \. "$NVM_DIR/bash_completion" \
  && nvm install 24.17.0 \
  && corepack enable yarn \
  && nvm cache clear
ENV PATH=/usr/local/lib/nvm/versions/node/v24.17.0/bin:$PATH

# Install NodeJS packages.
WORKDIR /tmp
COPY package.json ./
RUN set -x \
  && npm install -g $(jq -r '.dependencies | to_entries | map("\(.key)@\(.value)") | join(" ")' package.json) \
  && npm cache clean --force \
  && rm -f package.json

# Create App directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/system \
  && touch /opt/app/system/supervisor.ini \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/app
