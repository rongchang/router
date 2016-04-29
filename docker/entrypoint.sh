#! /bin/bash
SOURCE=$(dirname "${BASH_SOURCE[0]}")
set -e

### Feed configuration ###
ruby "$SOURCE/text_replace.rb" $SOURCE
ruby "$SOURCE/waiting_ports.rb" $SOURCE
echo '---- All ports online ----'

# sed 's,{{MYSQL_PASSWORD}},'"${MYSQL_ROOT_PASSWORD}"',g' -i /opt/nginx/nginx/conf/nginx.conf
# sed 's,{{MYSQL_HOST}},'"`getent hosts mysql | awk '{ print $1 }'`"',g' -i /opt/nginx/nginx/conf/nginx.conf

exec "$@"
