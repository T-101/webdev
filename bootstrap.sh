#!/usr/bin/env bash

# update and upgrade packages
apt-get update && sudo apt-get -y upgrade

# install needed tools
apt-get install -y apache2 php5 htop mosh npm git

# upgrade npm
npm cache clean -f
npm install -g npm

# fix ubuntu naming convention
ln -s /usr/bin/nodejs /usr/bin/node

# install n for managing node versions
npm install -g n

# make docroot for apache2 and meteor projects folder
sudo -u vagrant mkdir --mode=777 /vagrant/html
sudo -u vagrant echo '<p>Vagrant Apache docroot</p><p><a href="phpinfo.php">PHP</a></p>' > /vagrant/html/index.html
sudo -u vagrant echo '<?php phpinfo(); ?>' > /vagrant/html/phpinfo.php
sudo -u vagrant mkdir --mode=777 /vagrant/meteors

#install meteor
curl https://install.meteor.com | /bin/sh

# inject a script for creating meteor projects under vagrant shared folders
printf '
	#!/bin/bash

	if [ `whoami` != "root" ]; then
			echo "This must be run as root"
			exit
	fi

	if [ $# -eq 0 ]; then
			echo "Usage: $0 projectname"
	else
			CURRDIR=`pwd`
			sudo -u vagrant mkdir --mode=777 -p /vagrant/meteors
			sudo -u vagrant mkdir --mode=777 -p /home/vagrant/meteors/$1/.meteor/local
			cd /vagrant/meteors
			meteor create $1
			sudo mount --bind /home/vagrant/meteors/$1/.meteor/local/ /vagrant/meteors/$1/.meteor/local/
			echo "sudo mount --bind /home/vagrant/meteors/$1/.meteor/local/ /vagrant/meteors/$1/.meteor/local/" >> ~/.bashrc
			cd $CURRDIR
	fi
' > /home/vagrant/meteor.sh
chown vagrant:vagrant /home/vagrant/meteor.sh
chmod 777 /home/vagrant/meteor.sh


if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi