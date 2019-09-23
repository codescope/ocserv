#!/bin/bash
sed -i '/auth = "plain\[passwd=\/etc\/ocserv\/ocpasswd\]"/s/^/#/g' /etc/ocserv/ocserv.conf
sed -i '/^#auth = "radius\[config=\/etc\/radiusclient\-ng\/radiusclient\.conf,groupconfig=true\]"/s/^#//g' /etc/ocserv/ocserv.conf
sed -i '/^#acct = "radius\[config=\/etc\/radiusclient\-ng\/radiusclient\.conf\]"/s/^#//g' /etc/ocserv/ocserv.conf
rm -rf ./install_script.sh
rm -rf ./radius_for_ocserv.sh
rm -rf ./post_install_radius_script.sh
systemctl restart ocserv
sleep 2