#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo dnf update -y

# Install required dependencies
echo "Installing required dependencies..."
sudo dnf install -y wget curl epel-release

# Download and install aaPanel
echo "Downloading and installing aaPanel..."
wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0.sh
bash install.sh

# Install NGINX 1.4
echo "Installing NGINX 1.4..."
cd /usr/local/src
wget http://nginx.org/download/nginx-1.4.0.tar.gz
tar -zxvf nginx-1.4.0.tar.gz
cd nginx-1.4.0
./configure
make
sudo make install

# Install MariaDB 10.4
echo "Installing MariaDB 10.4..."
sudo tee /etc/yum.repos.d/MariaDB.repo > /dev/null <<EOL
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos9/x86_64
gpgkey=https://yum.mariadb.org/RPM-GPG-Key-MariaDB
gpgcheck=1
EOL
sudo dnf install -y MariaDB-server

# Start and enable MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Install PHP 7.4
echo "Installing PHP 7.4..."
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
sudo dnf module reset php
sudo dnf module enable php:remi-7.4
sudo dnf install -y php php-mysqlnd php-fpm php-cli

# Install MongoDB 7
echo "Installing MongoDB 7..."
echo "[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-7.repo

sudo dnf install -y mongodb-org

# Start and enable MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

echo "Installation completed! You can access aaPanel at http://your_server_ip:8888"
