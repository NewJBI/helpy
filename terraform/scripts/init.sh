#!/bin/bash
sudo rm -rf /etc/nginx/conf.d/default.conf
sudo mv /tmp/nginx.conf /etc/nginx/.
sudo mv /tmp/web-server.conf /etc/nginx/conf.d/.
sudo service nginx start
sudo mv /tmp/logrotate_rails /etc/logrotate.d/rails
sudo logrotate -f /etc/logrotate.conf
sudo echo '{ssh_public_key}' >> /home/deployer/.ssh/authorized_keys
