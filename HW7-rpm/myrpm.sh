#!/bin/bash

set -e
set -x

sudo su -l
cd ~
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
wget https://www.openssl.org/source/latest.tar.gz
tar -xvf latest.tar.gz
yum-builddep rpmbuild/SPECS/nginx.spec -y

sed -i.bkp  '/--with-debug/i \    \--with-openssl=/root/openssl-1.1.1d \\' rpmbuild/SPECS/nginx.spec
rpmbuild -bb rpmbuild/SPECS/nginx.spec

yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm 
systemctl start nginx

# своя репа
mkdir -p /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

sed -i.bkp  '/index  index.html index.htm;/a autoindex on;' /etc/nginx/conf.d/default.conf
nginx -s reload

createrepo /usr/share/nginx/html/repo/

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum -y -q reinstall nginx

