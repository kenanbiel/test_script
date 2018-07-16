#!/usr/bin/env bash

# Author: Kenan Virtucio

# CHECK ROOT OR SUDOER
if [[ ${EUID} -eq 0 ]]; then
   echo "This script can't be run as root or started via sudo by itself"
   exit 1
fi

sudocheck=$?

# CHECK IF USER HAS THE PERMISSION
if [[ ${sudocheck} -ne 0 ]]; then
   echo "You don't have the permission to do this operation"
   exit 1
fi

export packages="mysql-server php7.2 apache2"

# CHECK IF NECESSARY PACKAGES ARE INSTALLED
for package in ${packages}; do
   echo "Checking if package ${package} is installed"
   dpkg -l ${package}
   errcode=$?
   if [[ ${errcode} -ne 0 ]]; then
      echo "Package ${package} is not installed"
      exit 1
   else
      echo "Package ${package} is installed"
      echo
   fi
done

# WORDPRESS INSTALL
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass
echo "Run Wordpress Installation? (y/n)"
read -e run

# CHECK MYSQL INSTALLATION
mysql -u${dbuser} -p${dbpass} ${dbname} -e exit
errcode=$?
if [[ ${errcode} -ne 0 ]]; then
   echo "Something wrong happened with MySQL setup."
   echo "Please contact your Database Administrator."
   exit 1
else
   echo
fi

if [ ${run} -ne "y" ]; then
   echo "Wordpress installation halted by user!"
   exit 1
else
   # Wordpress Installation
   wget https://wordpress.org/latest.tar.gz
   tar -zxvf latest.tar.gz
   mv wordpress /var/www/
   rm -r latest.tar.gz
   cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
   sed -i "s/database_name_here/${dbname}/g" /var/www/wordpress/wp-config.php
   sed -i "s/username_here/${dbuser}/g" /var/www/wordpress/wp-config.php
   sed -i "s/password_here/${dbpass}/g" /var/www/wordpress/wp-config.php
   mkdir /var/www/wordpress/wp-content/uploads
   chmod 777 /var/www/wordpress/wp-content/uploads
fi
