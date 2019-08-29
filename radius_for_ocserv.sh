#!/bin/bash
function centos1_ntp(){
	setenforce 0
	sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
	yum -y install ntp
	service ntpd restart
	cd /root
	echo '0-59/10 * * * * /usr/sbin/ntpdate -u cn.pool.ntp.org' >> /tmp/crontab.back
	crontab /tmp/crontab.back
	systemctl restart crond
	yum install net-tools -y
	yum install epel-release -y
	systemctl stop firewalld
    systemctl disable firewalld
    yum install lynx wget expect iptables -y
}
function set_shell_input1() {
	sqladmin=0p0o0i0900
	yum install lynx -y
	public_ip=`lynx --source www.monip.org | sed -nre 's/^.* (([0-9]{1,3}\.){3}[0-9]{1,3}).*$/\1/p'`
	#解决ssh访问慢的问题,可以安装完脚本后手工重启ssh
	sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/g" /etc/ssh/sshd_config
	alias cp='cp'
	yum groupinstall "Development tools" -y
	yum install wget vim expect telnet net-tools httpd mariadb-server php php-mysql php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl curl-devel -y
	yum install freeradius freeradius-mysql freeradius-utils -y
	systemctl restart mariadb
	systemctl restart httpd
}

function set_freeradius3(){
	ln -s /etc/raddb/mods-available/sql /etc/raddb/mods-enabled/
	sed -i "s/auth = no/auth = yes/g" /etc/raddb/radiusd.conf
	sed -i "s/auth_badpass = no/auth_badpass = yes/g" /etc/raddb/radiusd.conf
	sed -i "s/auth_goodpass = no/auth_goodpass = yes/g" /etc/raddb/radiusd.conf
	sed -i "s/\-sql/sql/g" /etc/raddb/sites-available/default
	#在查找到的session {字符串后面插入内容
	sed -i '/session {/a\        sql' /etc/raddb/sites-available/default
	sed -i 's/driver = "rlm_sql_null"/driver = "rlm_sql_mysql"/g' /etc/raddb/mods-available/sql
    # allow any ipv4 address to access the freeradius server
    sed -i "s/ipaddr = 127.0.0.1/#/g" /etc/raddb/clients.conf
    sed -i "/ipv4addr = */s/^#//" /etc/raddb/clients.conf
	#查找到字符串，去掉首字母为的注释#
	sed -i '/read_clients = yes/s/^#//' /etc/raddb/mods-available/sql
	sed -i '/dialect = "sqlite"/s/^#//' /etc/raddb/mods-available/sql
	sed -i 's/dialect = "sqlite"/dialect = "mysql"/g' /etc/raddb/mods-available/sql	
	sed -i '/server = "localhost"/s/^#//' /etc/raddb/mods-available/sql
    sed -i 's/server = "localhost"/server = "167.86.94.70"/g' /etc/raddb/mods-available/sql
	sed -i '/port = 3306/s/^#//' /etc/raddb/mods-available/sql
	sed -i '/login = "radius"/s/^#//' /etc/raddb/mods-available/sql
    sed -i 's/login = "radius"/login = "ushatel_new_user"/g' /etc/raddb/mods-available/sql
	sed -i '/password = "radpass"/s/^#//' /etc/raddb/mods-available/sql
	sed -i 's/password = "radpass"/password = "Ushatel1397"/g' /etc/raddb/mods-available/sql	
    sed -i 's/radius_db = "radius"/radius_db = "ushatel_new_db"/g' /etc/raddb/mods-available/sql
	systemctl restart radiusd
    ystemctl restart mariadb.service 
	systemctl restart radiusd.service
	systemctl restart httpd
	sleep 3
}

function set_radiusclient8(){
	yum install radiusclient-ng -y
	echo "localhost testing123" >> /etc/radiusclient-ng/servers
echo "==========================================================================
                  Centos7 VPN 安装完成                            
										 
				  以下信息将自动保存到/root/info.txt文件中
		                             
		           如果采用radius认证，需要注释/etc/ocserv/ocserv.conf文件中的下面行密码认证行
			   auth = "plain[passwd=/etc/ocserv/ocpasswd]"
			   #下面的方法是使用radius验证用户，如果使用radius，请注释上面的密码验证
			   #auth = "radius[config=/etc/radiusclient-ng/radiusclient.conf,groupconfig=true]"
			   #下面这句加上之后，daloradius在线用户中可以看到用户在线
			   #acct = "radius[config=/etc/radiusclient-ng/radiusclient.conf]"
			   修改完成之后执行systemctl restart ocserv 命令重启ocserv

==========================================================================" > /root/info.txt
	cat /root/info.txt
	exit;
}

function shell_install() {
centos1_ntp
set_shell_input1
set_freeradius3
set_radiusclient8
}
shell_install
