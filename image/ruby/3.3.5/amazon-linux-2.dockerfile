# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN set -x \
  && yum install -y openssl-devel zlib-devel libyaml-devel libffi-devel postgresql-devel

# Download and extract Ruby.
WORKDIR /tmp
RUN set -x \
  && wget https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.5.tar.gz --quiet \
  && tar xvzf ruby-3.3.5.tar.gz > /dev/null

# Compile and install Ruby.
WORKDIR ruby-3.3.5
RUN set -x \
  && ./configure \
  && make \
  && make install

# Install Ruby packages.
RUN set -x \
  && gem install bundler \
  && gem install rails -v 7.2.1 \
  && gem install pg -v 1.1.4

# Create App directories.
WORKDIR ../
RUN set -x \
  && rm -rf ruby-3.3.5* \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/system \
  && touch /opt/app/system/supervisor.ini \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/app
