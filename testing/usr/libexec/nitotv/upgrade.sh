#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
apt-get update
apt-get -y -u dist-upgrade 1>/tmp/aptoutput 2>/tmp/aptoutput
exitcode=$?
echo "upgrade exited with" $exitcode
exit $exitcode

