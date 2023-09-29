# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y xz

# Switch work directory.
WORKDIR /tmp

# Download, extract, and install NodeJS.
RUN set -x \
  && wget https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz --quiet \
  && tar xvJf node-v14.16.0-linux-x64.tar.xz > /dev/null \
  && mkdir /usr/local/lib/node-js \
  && cp -r node-v14.16.0-linux-x64/* /usr/local/lib/node-js/ \
  && rm -rf node-v14.16.0-linux-x64*

# Install NodeJS packages.
ENV PATH=/usr/local/lib/node-js/bin:$PATH
ENV NODE_PATH=/opt/app/node_modules
RUN set -x \
  && npm install mongodb@3.6.5 \
  && npm install express@4.17.1 \
  && npm install yargs@17.7.2

# Create App directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && history -c

# Set default work directory.
WORKDIR /opt/app
