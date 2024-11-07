#!/bin/bash


export RDS_DB_NAME=$1
export RDS_USERNAME=$2
export RDS_PASSWORD=$3
export RDS_ENDPOINT=$4

export REDIS_HOST=$5
export REDIS_PORT=$6


sudo apt update -y
sudo apt install -y apache2 php php-mysqlnd php-redis mysql-server

sudo systemctl start apache2
sudo systemctl enable apache2

cd /var/www/html/
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo chown -R www-data:www-data /var/www/html/

cd /var/www/html
cp wp-config-sample.php wp-config.php
sudo mv wordpress/* .
sudo rm -rf wordpress latest.tar.gz index.html
sudo mv wp-config-sample.php wp-config.php

sudo sed -i "s/database_name_here/${RDS_DB_NAME}/" wp-config.php
sudo sed -i "s/username_here/${RDS_USERNAME}/" wp-config.php
sudo sed -i "s/password_here/${RDS_PASSWORD}/" wp-config.php
sudo sed -i "s/localhost/${RDS_ENDPOINT}/" wp-config.php
echo "define('WP_REDIS_HOST', '${REDIS_HOST}');" | sudo tee -a wp-config.php
echo "define('WP_REDIS_PORT', ${REDIS_PORT});" | sudo tee -a wp-config.php
echo "define('WP_REDIS_PASSWORD', '${RDS_PASSWORD}');" | sudo tee -a wp-config.php

echo "Deployment complete. Access WordPress at your EC2 instance's public IP."
    

