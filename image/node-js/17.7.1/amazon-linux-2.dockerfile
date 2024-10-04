# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y xz gcc-c++

# Install NodeJS.
WORKDIR /tmp
RUN set -x \
  && wget https://nodejs.org/dist/v17.7.1/node-v17.7.1-linux-x64.tar.xz --quiet \
  && tar xvJf node-v17.7.1-linux-x64.tar.xz > /dev/null \
  && mkdir /usr/local/lib/node-js \
  && cp -r node-v17.7.1-linux-x64/* /usr/local/lib/node-js/ \
  && rm -rf node-v17.7.1-linux-x64*
ENV PATH=/usr/local/lib/node-js/bin:$PATH
ENV NODE_PATH=/usr/local/lib/node-js/lib/node_modules

# Install NodeJS packages.
RUN set -x \
   && npm install -g mongodb@3.6.5 \
   && npm install -g express@4.17.1 \
   && npm install -g yargs@17.7.2

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
