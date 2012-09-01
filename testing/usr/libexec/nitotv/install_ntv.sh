#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
apt-get update
apt-get install -y --force-yes $1 1>/tmp/aptoutput 2>/tmp/aptoutput
#apt-get install -y $1
exitcode=$?
#rm -rf /tmp/aptoutput &> /dev/null
echo "install_ntv exited with" $exitcode
exit $exitcode

