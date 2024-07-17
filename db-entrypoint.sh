#!/bin/bash

# Start MySQL service
service mysql start

# Set up MySQL database and user
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Start Apache service
service apache2 start

# Keep the container running
tail -f /dev/null

