# MariaDB Galera 10
FROM bjohnson/cloudbase
MAINTAINER Brendan Johnson <bjohnson@paragusit.com>

ENV TERM dumb

# Install Mariadb Galera
RUN \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
  apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
  echo "deb http://mirror.netcologne.de/mariadb/repo/10.0/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/mariadb.list && \
  echo 'deb http://repo.percona.com/apt wheezy main' > /etc/apt/sources.list.d/percona.list && \
  apt-get update && \
  echo mariadb-galera-server-10.0 mysql-server/root_password password root | debconf-set-selections && \
  echo mariadb-galera-server-10.0 mysql-server/root_password_again password root | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
					galera \
					inotify-tools \
					mariadb-client \
					mariadb-galera-server \
					percona-xtrabackup \
					socat

ADD ./my.cnf /etc/mysql/my.cnf
# RUN service mysql restart 
RUN mkdir -p /data

expose	3306 4444 4567 4568

ADD start /bin/start
RUN chmod +x /bin/start
