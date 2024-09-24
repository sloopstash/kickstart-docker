# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install dependencies and tools.
RUN set -x \
 && yum update -y \
 && yum groupinstall -y "Development Tools" \
 && yum install -y openssl-devel readline-devel zlib-devel libyaml-devel libffi-devel make curl

# Install Ruby.
RUN set -x \
 && wget https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.5.tar.gz \
 && tar -xzvf ruby-3.3.5.tar.gz \
 && cd ruby-3.3.5 \
 && ./configure \
 && make \
 && make install 

# Install Bundler
RUN gem install bundler

# Install Rails.
RUN gem install rails -v 7.2.1

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
