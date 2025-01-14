# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y xz

# Install JQ.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64 --quiet \
  && mv jq-linux-amd64 /usr/local/bin/jq \
  && chmod +x /usr/local/bin/jq

# Install NodeJS.
RUN set -x \
  && wget https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz --quiet \
  && tar xvJf node-v14.16.0-linux-x64.tar.xz > /dev/null \
  && mkdir /usr/local/lib/node-js \
  && cp -r node-v14.16.0-linux-x64/* /usr/local/lib/node-js/ \
  && rm -rf node-v14.16.0-linux-x64*
ENV PATH=/usr/local/lib/node-js/bin:$PATH
ENV NODE_PATH=/usr/local/lib/node-js/lib/node_modules

# Install NodeJS packages.
COPY package.json ./
RUN set -x \
  && npm install -g $(jq -r '.dependencies | to_entries | map("\(.key)@\(.value)") | join(" ")' package.json) \
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
