# Docker file for Lime Survey
FROM centos:7
MAINTAINER Tk

# Install Nginx
COPY nginx.repo /etc/yum.repos.d/
RUN yum -y update && yum -y install nginx

# Config Nginx for php
COPY default.conf /etc/nginx/conf.d/
 
# Install PHP 5.6
RUN yum -y install epel-release && yum -y update
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum -y install --enablerepo=remi,remi-php56 php-fpm php-mbstring php-gd php-imap php-ldap php-zip php-zlib php-mysqlnd php-xml

# Config php-fpm 
RUN sed -i -e "s/^user\s=\sapache$/user = nginx/g" /etc/php-fpm.d/www.conf
RUN sed -i -e "s/^group\s=\sapache$/group = nginx/g" /etc/php-fpm.d/www.conf
RUN chgrp -R nginx /var/lib/php/{session,wsdlcache}

# Install Mariadb
RUN yum -y install mariadb-server

# Config Mariadb
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql/

# Download Limesurvey
RUN mkdir -p /var/www
RUN curl -L -o /tmp/limesurvey.tar.gz  http://www.d-ip.jp/download/images/limesurvey2.73.0+171219_ja_dip.tar.gz
RUN tar zxf /tmp/limesurvey.tar.gz -C /var/www &&  \
    mv /var/www/limesurvey /var/www/survey && \
    chown -R nginx.nginx /var/www/survey

# Set startup
COPY start.sh /root/
CMD ["/root/start.sh"]
