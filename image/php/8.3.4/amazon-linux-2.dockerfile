# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages required for PHP + Drupal.
RUN set -x \
  && yum install -y amazon-linux-extras wget gcc gcc-c++ make autoconf bison re2c libxml2-devel sqlite-devel openssl-devel curl-devel libpng-devel libjpeg-devel freetype-devel oniguruma-devel libzip-devel libicu-devel bzip2-devel \
  && yum clean all

# Download and extract PHP.
WORKDIR /tmp
RUN set -x \
  && wget https://www.php.net/distributions/php-8.3.4.tar.gz --quiet \
  && tar xvzf php-8.3.4.tar.gz > /dev/null

# Compile and install PHP.
WORKDIR php-8.3.4
RUN set -x \
  && export CC="gcc" \
  && export CFLAGS="-fPIE" \
  && export CXXFLAGS="-fPIE" \
  && export LDFLAGS="-pie" \
  && ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --enable-mysqlnd --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-openssl --with-curl --with-zlib --enable-mbstring --enable-intl --enable-opcache --enable-gd --with-jpeg --with-freetype --with-zip \
  && make clean \
  && make -j$(nproc) \
  && make install

# Configure PHP-FPM.
RUN set -x \
  && mkdir -p /usr/local/php/etc \
  && cp php.ini-production /usr/local/php/etc/php.ini \
  && cp sapi/fpm/php-fpm.conf /usr/local/php/etc/php-fpm.conf \
  && mkdir -p /usr/local/php/etc/php-fpm.d \
  && cp sapi/fpm/www.conf /usr/local/php/etc/php-fpm.d/www.conf \
  && sed -i 's#^listen =.*#listen = 0.0.0.0:9000#' /usr/local/php/etc/php-fpm.d/www.conf \
  && sed -i 's#^;daemonize = yes#daemonize = no#' /usr/local/php/etc/php-fpm.conf

# Add PHP to PATH.
ENV PATH=/usr/local/php/bin:/usr/local/php/sbin:$PATH

# Create App directories.
WORKDIR /tmp
RUN set -x \
  && rm -rf php-8.3.4* \
  && mkdir -p /opt/app/source \
  && mkdir -p /opt/app/log \
  && mkdir -p /opt/app/system \
  && touch /opt/app/system/supervisor.ini \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/app