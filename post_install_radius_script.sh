#!/bin/bash
sed -i '/auth = "plain\[passwd=\/etc\/ocserv\/ocpasswd\]"/s/^/#/g' /etc/ocserv/ocserv.conf
sed -i '/^#auth = "radius\[config=\/etc\/radiusclient\-ng\/radiusclient\.conf,groupconfig=true\]"/s/^#//g' /etc/ocserv/ocserv.conf
sed -i '/^#acct = "radius\[config=\/etc\/radiusclient\-ng\/radiusclient\.conf\]"/s/^#//g' /etc/ocserv/ocserv.conf
systemctl restart ocserv
sleep 2