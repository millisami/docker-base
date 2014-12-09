FROM       ubuntu:14.04
MAINTAINER Sachin Sagar Rai <millisami@gmail.com>

# Ensure UTF-8 locale
COPY locale /etc/default/locale
RUN locale-gen en_US.UTF-8 &&\
  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales &&\
  # Install build dependencies
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  build-essential \
  libcurl4-openssl-dev \
  python-dev \
  python-setuptools \
  python-software-properties \
  software-properties-common &&\
  # Add official git APT repository
  apt-add-repository ppa:git-core/ppa &&\
  # Add Chris Lea NodeJS repository
  apt-add-repository ppa:chris-lea/node.js &&\
  # Add Brightbox ruby repository
  apt-key adv --keyserver keyserver.ubuntu.com --recv C3173AA6 &&\
  echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" > /etc/apt/sources.list.d/bbruby.list &&\
  # Add PostgreSQL Global Development Group apt source
  echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&\
  # Add PGDG repository key
  wget -qO - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - &&\
  # Update apt cache with PPAs
  apt-get update &&\
  # Install git and ruby
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  ruby2.1 &&\
  # Install bundler globally
  /bin/bash -l -c 'gem install --no-doc --no-ri bundler' &&\
  # Install Ruby application dependencies
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libpq-dev \
  postgresql-client-9.3 \
  nodejs \
  libreadline-dev \
  zlib1g-dev \
  flex \
  bison \
  libxml2-dev \
  libxslt1-dev \
  libssl-dev \
  imagemagick \
  vim \
  curl \
  supervisor &&\
  # Clean up APT and temporary files when done
  apt-get clean &&\
  DEBIAN_FRONTEND=noninteractive apt-get remove --purge -y wget &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
