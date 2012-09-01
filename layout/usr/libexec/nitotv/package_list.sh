#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
apt-get update
apt-cache pkgnames 1>/tmp/aptpkg
exitcode=$?
exit $exitcode