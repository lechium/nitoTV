#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
apt-cache search $1 1>/tmp/pkgsearch
exitcode=$?
exit $exitcode