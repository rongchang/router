#! /bin/bash

set -e

### Feed configuration ###
sed 's,{{MYSQL_PORT_3306_TCP_ADDR}},'"${MYSQL_PORT_3306_TCP_ADDR}"',g' -i /opt/nginx/nginx/conf/nginx.conf
sed 's,{{MYSQL_PORT_3306_TCP_PORT}},'"${MYSQL_PORT_3306_TCP_PORT}"',g' -i /opt/nginx/nginx/conf/nginx.conf
sed 's,{{MYSQL_USER}},'"${MYSQL_USER}"',g' -i /opt/nginx/nginx/conf/nginx.conf
sed 's,{{MYSQL_PASSWORD}},'"${MYSQL_PASSWORD}"',g' -i /opt/nginx/nginx/conf/nginx.conf
sed 's,{{MYSQL_DATABASE}},'"${MYSQL_DATABASE}"',g' -i /opt/nginx/nginx/conf/nginx.conf

exec "$@"
