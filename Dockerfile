FROM       ubuntu
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
  g++ \
  cmake \
  python-software-properties \
  software-properties-common &&\
  # Add official git APT repository
  apt-add-repository ppa:git-core/ppa &&\
  # Add Chris Lea NodeJS repository
  apt-add-repository ppa:chris-lea/node.js &&\
  # Add PostgreSQL Global Development Group apt source
  echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&\
  # Add PGDG repository key
  wget -qO - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - &&\
  # Install ruby-install
  cd /tmp &&\
  wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz &&\
  tar -xzvf ruby-install-0.5.0.tar.gz &&\
  cd ruby-install-0.5.0/ &&\
  make install &&\
  # Update apt cache with PPAs
  apt-get update &&\
  # Install git and ruby
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git &&\
  # Install MRI Ruby 2.1.2
  ruby-install --system ruby 2.1.2 &&\
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
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
