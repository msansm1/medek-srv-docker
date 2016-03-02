#!/bin/bash

if [ ! -f /home/.wildfly_admin_created ]; then
  /create_wildfly_admin_user.sh
fi

service apache2 start

service mysql start

exec /home/wildfly/bin/standalone.sh --debug
