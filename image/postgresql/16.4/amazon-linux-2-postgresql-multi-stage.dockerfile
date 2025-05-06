# Select the base image to build the PostgreSQL image
FROM sloopstash/base:v1.1.1 AS install_system_packages

# install system packages 
RUN set -x \
  && yum install -y zlib-devel libicu-devel readline-devel

# Download and Install the PostgreSQL packages
FROM install_system_packages AS install_postgresql_packages

# Set default working directroy 
WORKDIR /tmp

# Download and extract the PostgreSQL packages
RUN set -x \
  && wget https://ftp.postgresql.org/pub/source/v16.4/postgresql-16.4.tar.gz --quiet \
  && tar xvzf postgresql-16.4.tar.gz > /dev/null

# Compile and install PostgreSQL.
# Set working directory
WORKDIR postgresql-16.4

# Install the PostgrSQL package
RUN set -x \
  && ./configure \
  && make \
  && make install

# System configuration for PostgreSQL 
FROM sloopstash/base:v1.1.1 AS psql_system_configuration

# Create the PostgreSQL Directories
RUN set -x \
  && mkdir /opt/postgresql \
  && mkdir /opt/postgresql/data \
  && mkdir /opt/postgresql/log \
  && mkdir /opt/postgresql/conf \
  && mkdir /opt/postgresql/script \
  && mkdir /opt/postgresql/system \
  && touch /opt/postgresql/system/server.pid \
  && touch /opt/postgresql/system/supervisor.ini 
   
# Finalize the image building 
FROM sloopstash/base:v1.1.1 AS finilize_image_build
COPY --from=install_postgresql_packages /usr/local/pgsql/ /usr/local/pgsql/
COPY --from=install_postgresql_packages /usr/lib64/ /usr/lib64/
COPY --from=psql_system_configuration /opt/postgresql /opt/postgresql

# Create the DB user
RUN useradd -m postgresql
# Enable write permission to user postgresql to DB files
RUN chown -R postgresql:postgresql /opt/postgresql

# Set Environment variables for executable files path 
ENV PATH=/usr/local/pgsql/bin:$PATH

# install libicu 
#RUN yum install libicu -y

# Run PostgreSQL from supervisor
RUN set -x \
  RUN set -x \
  && ln -s /opt/postgresql/system/supervisor.ini /etc/supervisord.d/postgresql.ini \
  && history -c

#Set Default Working directory
WORKDIR /opt/postgresql
