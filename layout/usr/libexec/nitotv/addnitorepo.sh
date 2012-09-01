#!/bin/bash
export PATH=/usr/bin:/bin:/sbin:/usr/sbin
echo "deb http://apt.awkwardtv.org/ stable main" > /etc/apt/sources.list.d/awkwardtv.list
wget -O- http://apt.awkwardtv.org/awkwardtv.pub | apt-key add -