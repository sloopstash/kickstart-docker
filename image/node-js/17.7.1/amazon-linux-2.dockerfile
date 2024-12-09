# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y xz gcc-c++ wget

# Install NodeJS (version 17.7.1)
WORKDIR /tmp
RUN wget https://nodejs.org/dist/v17.7.1/node-v17.7.1-linux-x64.tar.xz --quiet \
  && tar xvJf node-v17.7.1-linux-x64.tar.xz > /dev/null \
  && mkdir /usr/local/lib/node-js \
  && cp -r node-v17.7.1-linux-x64/* /usr/local/lib/node-js/ \
  && rm -rf node-v17.7.1-linux-x64*
ENV PATH=/usr/local/lib/node-js/bin:$PATH
ENV NODE_PATH=/usr/local/lib/node-js/lib/node_modules

# Create App directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/system \
  && touch /opt/app/system/supervisor.ini \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Create necessary directories (frontend, backend)
RUN mkdir -p /opt/app/source/view /opt/app/source /opt/app/log /opt/app/system

# Copy frontend and backend package.json
COPY ./view/package.json /opt/app/source/view/package.json
COPY ./package.json /opt/app/source/package.json

# Copy frontend source code
COPY view/ /opt/app/source/view/

# Install frontend dependencies and build
WORKDIR /opt/app/source/view
RUN npm install \
  && npm run build

# Copy backend source code
COPY ./ /opt/app/source/

# Install backend dependencies
WORKDIR /opt/app/source
RUN npm install

# Set default work directory.
WORKDIR /opt/app
