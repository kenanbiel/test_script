#!/usr/bin/env bah

# Author: Kenan Virtucio
# Works with CentOS 6.8

# Install EPEL
wget http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/x86_64/epel-release-6-7.noarch.rpm
rpm -ivh epel-release-6-7.noarch.rpm

# Install Cacti Related Packages

yum install fail2ban httpd php php-mysql php-snmp php-gd mysql mysql-server net-snmp mod_ssl patch net-snmp net-snmp-utils net-snmp-devel

yum install cacti

# Configure Cacti

sed -i "s/database_password/${dbpassword}/g" /etc/cacti/db.php

# Install Spine

yum groupinstall "Development Tools"
yum install libtool dos2unix autoconf automake make binutils libtool gcc cpp glibc-headers kernel-headers glibc-devel policycoreutils-python
yum install mysql-devel openssl-devel
wget http://www.cacti.net/downloads/spine/cacti-spine-0.8.8b.tar.gz

# Configure Spine
tar xvzf cacti-spine-0.8.8b.tar.gz 
cd cacti-spine-0.8.8b
sh bootstrap
./configure
make
make install
cd /usr/local/spine/etc/
cp spine.conf.dist spine.conf

# Install Cacti Plugins
cd /usr/share/cacti/plugins

wget http://docs.cacti.net/_media/plugin:settings-v0.71-1.tgz
tar -xvfz plugin:settings-v0.71-1.tgz

wget http://docs.cacti.net/_media/plugin:thold-v0.4.9-3.tgz
tar -xvfz plugin:thold-v0.4.9-3.tgz

wget http://docs.cacti.net/_media/plugin:monitor-v1.3-1.tgz
tar -xvfz plugin:monitor-v1.3-1.tgz

wget http://docs.cacti.net/_media/plugin:realtime-v0.5-2.tgz
tar -xvfz plugin:realtime-v0.5-2.tgz

chown -R root:root /usr/share/cacti/plugins/* 
chmod -R 755 /usr/share/cacti/plugins/realtime 
chmod -R 755 /usr/share/cacti/plugins/settings 
chmod -R 755 /usr/share/cacti/plugins/thold
chmod -R 755 /usr/share/cacti/plugins/monitor
mkdir /usr/share/cacti/realtime-rrd
chown -R apache:root /usr/share/cacti/realtime-rrd
chcon -R -t httpd_cache_t /usr/share/cacti/realtime-rrd


