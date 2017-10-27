#!/bin/bash

#install library
yum update -y
yum install -y epel-release patch autoconf automake bison gcc-c++ libffi-devel libtool readline readline-devel sqlite-devel zlib zlib-devel glibc-headers glibc-devel libyaml-devel openssl-devel make bzip2 autoconf automake mysql mysql-devel ImageMagick git git-core
yum install -y nginx
yum install -y nodejs
yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
yum install -y postgresql96-devel 
yum install -y postgresql96-libs
yum install -y postgresql-devel
yum install -y policycoreutils
export LC_ALL="en_US.UTF-8"

#add user deployer
useradd deployer -m
echo 'deployer ALL=(ALL)      NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

#create folder .ssh authorized_keys
mkdir /home/deployer/.ssh  
chown -R deployer:deployer /home/deployer/.ssh  
chmod 700 /home/deployer/.ssh  
chmod 600 /home/deployer/.ssh/authorized_keys  
mkdir -p /srv/www/apps/helpy/shared/config/
chown -R deployer:deployer /srv/www/apps

sed -i 's/^.*PermitUserEnvironment no/PermitUserEnvironment yes/g' /etc/ssh/sshd_config
touch ~/.ssh/environment
echo 'export LC_ALL="en_US.UTF-8"' >> ~/.ssh/environment

#add inbound port for centos
lokkit -p 80:tcp
lokkit -p 443:tcp
semanage port -a -t http_port_t -p tcp 80
semanage port -a -t http_port_t -p tcp 443
setenforce 1
semanage permissive -a httpd_t

#add rbenv for user deployer
git clone https://github.com/rbenv/rbenv.git /home/deployer/.rbenv
cd /home/deployer/.rbenv && src/configure && make -C src
echo 'export PATH="/home/deployer/.rbenv/bin:$PATH"' >> ~/.bash_profile

git clone git://github.com/sstephenson/rbenv.git /home/deployer/.rbenv
echo 'export PATH="/home/deployer/.rbenv/bin:$PATH"' >> /home/deployer/.bash_profile
echo 'eval "$(rbenv init -)"' >> /home/deployer/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git /home/deployer/.rbenv/plugins/ruby-build

chown -R deployer:deployer /home/deployer/.rbenv
runuser -l deployer -c "cd ~ \
 && source ~/.bash_profile \
 && rbenv install 2.3.0 \
 && rbenv rehash \
 && rbenv global 2.3.0 \
 && gem install bundler \
 && gem install rails
"
