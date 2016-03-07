#! /bin/bash

set -e

### Feed configuration ###
sed 's,{{MYSQL_PASSWORD}},'"${MYSQL_ROOT_PASSWORD}"',g' -i /opt/nginx/nginx/conf/nginx.conf
sed 's,{{MYSQL_HOST}},'"`getent hosts mysql | awk '{ print $1 }'`"',g' -i /opt/nginx/nginx/conf/nginx.conf

exec "$@"
