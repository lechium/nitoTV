#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
apt-get -y --force-yes remove $1 1>/tmp/aptoutput 2>/tmp/aptoutput
#apt-get autoremove -y --force-yes 1>/tmp/aptoutput 2>/tmp/aptoutput
exitcode=$?
#rm -rf /tmp/aptoutput &> /dev/null
exit $exitcode
