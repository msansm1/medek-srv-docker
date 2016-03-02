#!/bin/bash

if [ -f /home/wildfly/.wildfly_admin_created ]; then
  echo "The WildFly 'admedek' user has already been created."
  exit 0
fi

#generate password
PASS="medek2014wildfly"
echo "=> Creating the WildFly user 'admedek' with the password '${PASS}'."
/home/wildfly/bin/add-user.sh admedek ${PASS} --silent
echo "=> Done!"
touch /home/wildfly/.wildfly_admin_created
echo "========================================================================="
echo ""
echo "  You can now configure this WildFly server using:"
echo ""
echo "  admedek:${PASS}"
echo ""
echo "========================================================================="