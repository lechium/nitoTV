#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
dpkg -l 1>/tmp/installed_dpkg
exitcode=$?
exit $exitcode