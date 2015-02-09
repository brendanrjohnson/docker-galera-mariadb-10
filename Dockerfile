# MariaDB Galera 10
# FROM bjohnson/cloudbase-ubuntu:14.04
FROM docker-registry.paragusit.com/cloudbase-ubuntu:14.04
MAINTAINER Brendan Johnson <bjohnson@paragusit.com>

ENV TERM dumb

# Install Prequisites
RUN \
  apt-get update && apt-get -yq install \
    ca-certificates \
    curl \
		inotify-tools \
    locales \
    lsb-release \
    lsof \
    make \
    netcat \
    net-tools \
		socat \
    strace \
    sudo \
    vim \
    --no-install-recommends

# generate a local to suppress warnings
RUN locale-gen en_US.UTF-8

RUN \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
  apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
  echo "deb http://mirror.netcologne.de/mariadb/repo/10.0/ubuntu `lsb_release -cs` main" > \
    /etc/apt/sources.list.d/mariadb.list && \
  echo "deb http://repo.percona.com/apt `lsb_release -cs` main" > /etc/apt/sources.list.d/percona.list

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
      mariadb-client \
      mariadb-galera-server \
      percona-xtrabackup \
      rsync && \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  rm -rf /var/lib/mysql/* && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# download and install latest stable etcdctl and confd
RUN \
  curl -o /usr/local/bin/etcdctl https://s3-us-west-2.amazonaws.com/opdemand/etcdctl-v0.4.5 && \
  chmod +x /usr/local/bin/etcdctl && \
  curl -o /usr/local/bin/confd https://s3-us-west-2.amazonaws.com/opdemand/confd-v0.5.0-json && \
  chmod +x /usr/local/bin/confd

# Define mountable directories.
VOLUME ["/var/lib/mysql"]

COPY . /app

# Define working directory.
WORKDIR /app

RUN chmod +x /app/bin/*

# Define default command.
CMD ["/app/bin/boot"]

# Expose ports.
EXPOSE 3306 4444 4567 4568
