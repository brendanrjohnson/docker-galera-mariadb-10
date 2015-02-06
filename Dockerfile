# MariaDB Galera 10
FROM bjohnson/cloudbase
MAINTAINER Brendan Johnson <bjohnson@paragusit.com>


# Install Mariadb Galera
RUN \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
  echo "deb http://mirror.netcologne.de/mariadb/repo/10.0/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/mariadb.list && \
  apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
  echo 'deb http://repo.percona.com/apt wheezy main' > /etc/apt/sources.list.d/percona.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install mariadb-galera-server galera percona-xtrabackup inotify-tools pwgen socat \
                                                    python-software-properties software-properties-common rsync netcat-openbsd

RUN cp /etc/mysql/my.cnf /etc/mysql/my.cnf~
ADD etc/mysql /etc/mysql
RUN chmod 644 /etc/mysql/my.cnf

# Set data and log directories
VOLUME ["/conf"]
VOLUME ["/data"]
VOLUME ["/log"]

ADD start.sh /start.sh
RUN chmod +x start.sh

ENTRYPOINT ["/start.sh"]
