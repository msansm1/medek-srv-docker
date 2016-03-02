FROM debian

MAINTAINER Msansm1 <msansm1@dizalch.fr>

ENV WILDFLY_VERSION 10.0.0.Final
ENV JBOSS_HOME /home/wildfly 
ENV BUILD_PACKAGES curl mysql-server vim openjdk-8-jdk javascript-common libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libdbd-mysql-perl libdbi-perl libgd3 libjs-jquery libjs-sphinxdoc libjs-underscore liblua5.1-0 libmcrypt4 libmysqlclient18 libonig2 libqdbm14 libterm-readkey-perl libvpx1 libxpm4 mysql-client mysql-client-5.5 mysql-common php-gettext php-tcpdf php5-cli php5-common php5-gd php5-json php5-mcrypt php5-mysql php5-readline ssl-cert unzip apache2 apache2-bin apache2-data apache2-utils libapache2-mod-php5

COPY run.sh /
COPY create_wildfly_admin_user.sh /
COPY standalone.xml /
COPY mysql.tar.gz /
COPY default /
COPY create.sql /
COPY load.sql /
COPY mysql_user.sql /
COPY phpMyAdmin-4.5.4.1-all-languages.zip /
COPY phpmyadmin.conf /

RUN DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://ftp.fr.debian.org/debian jessie-backports main" >> /etc/apt/sources.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $BUILD_PACKAGES --no-install-recommends && \
    apt-get clean -qq &&\
	curl -Ls "http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz" \
    | tar -xzC /home --no-same-owner && \
    rm -rf /var/lib/apt/lists/* && \  
    ln -s /home/wildfly-$WILDFLY_VERSION $JBOSS_HOME && \
    groupadd -r wildfly -g 433 && \
    useradd -u 431 -r -g wildfly -d $JBOSS_HOME -s /bin/false -c "WildFly user" wildfly && \
    chmod +x /create_wildfly_admin_user.sh /run.sh && \
    cat /mysql.tar.gz | tar -zxC /home/wildfly/modules/system/layers/base/com --no-same-owner && \
    mv -f /standalone.xml /home/wildfly/standalone/configuration/ && \
	mkdir /opt/medek &&\
	mkdir /opt/medek/fs &&\
    mv -f /default /etc/apache2/sites-available/000-default.conf && \
    a2enmod expires headers cache proxy proxy_balancer proxy_http proxy_ajp ssl rewrite && \
	unzip /phpMyAdmin-4.5.4.1-all-languages.zip && \
	mv /phpMyAdmin-4.5.4.1-all-languages /usr/share/phpmyadmin && \
	mv /phpmyadmin.conf /etc/apache2/conf-available/ && \
	a2enconf phpmyadmin &&\
	service mysql start && \
    mysqladmin -u root password "MYSQLmedek" && \
    mysql -u root -pMYSQLmedek -h localhost < /create.sql && \
    mysql -u root -pMYSQLmedek -h localhost -b meddb < /load.sql && \
    mysql -u root -pMYSQLmedek -h localhost -b meddb < /mysql_user.sql
	
CMD ["/run.sh"]

