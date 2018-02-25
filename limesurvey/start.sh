#!/bin/sh

nohup /usr/bin/mysqld_safe &
/usr/sbin/nginx -c /etc/nginx/nginx.conf &
/usr/sbin/php-fpm --nodaemonize
