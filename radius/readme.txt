如果需要把 radius服务器 和 ocserv 服务器部署到不同的服务器，需要配置下的的文件
If you need to deploy the radius server and ocserv server to different servers, you need to configure the files.
1、Ocserv Server
iptables -I INPUT -p tcp --dport 1812 -j ACCEPT
iptables -I INPUT -p tcp --dport 1812 -j ACCEPT
iptables -I INPUT -p udp --dport 1813 -j ACCEPT
iptables -I INPUT -p udp --dport 1813 -j ACCEPT

vim /etc/raddb/clients.conf
Change below
ipv4addr = *
secret = testing123

2、install radiusclient for Ocserv server
yum install radiusclient-ng -y

vi /etc/radiusclient-ng/radiusclient.conf
You need to specify the address of the radius server, modify the following two lines, here you assume that you have set up the radius server and the IP is 1.2.3.4:

authserver 1.2.3.4
acctserver 1.2.3.4

vi /etc/radiusclient-ng/servers
add below

1.2.3.4        some-pass

If you use radius authentication, you need to comment below line at the /etc/ocserv/ocserv.conf file
auth = "plain[passwd=/etc/ocserv/ocpasswd]"
 #下面的方法是使用radius验证用户，如果使用radius，请注释上面的密码验证
#auth = "radius[config=/etc/radiusclient-ng/radiusclient.conf,groupconfig=true]"
#下面这句加上之后，daloradius在线用户中可以看到用户在线
#acct = "radius[config=/etc/radiusclient-ng/radiusclient.conf]"
修改完成之后执行systemctl restart ocserv 命令重启ocserv

修改phpmail乱码问题
vi /var/www/html/user_reg_new/mailer/class.phpmailer.php
修改其中的public $CharSet = ‘iso-8859-1′; 改为 public $CharSet = ‘UTF-8′;
