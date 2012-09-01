#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
apt-cache show $1 1>/tmp/pkginfo
exitcode=$?
exit $exitcode