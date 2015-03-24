#!/bin/bash

apt-get -y update && \
apt-get -y install wget git curl nano && \
apt-get -y install openjdk-7-jdk && \
apt-get -y install postgresql postgresql-client && \
apt-get -y install postgis && \
apt-get -y install tomcat7 && 
apt-get -y install ant
apt-get -y install postgresql-9.3-postgis-scripts

# define working dir
cd /


# get the whole project from github
rm -rf poi_fusion_engine2
git clone https://github.com/satrd/poi_fusion_engine2


# postGIS server. Start server and add a database
service postgresql restart
sudo -u postgres psql << EOF
        DROP DATABASE IF EXISTS ocd_valencia;
        DROP USER IF EXISTS fic2;
        CREATE USER fic2 WITH PASSWORD 'eneko';
        CREATE DATABASE ocd_valencia WITH ENCODING='UTF8' TEMPLATE="template0" OWNER=fic2 CONNECTION LIMIT=-1;
EOF

sudo -u postgres psql ocd_valencia << EOF
        create extension postgis;
        create extension postgis_topology;
EOF

sudo -u postgres psql -d ocd_valencia -f poi_fusion_engine2/services/ocd_valencia.sql

service tomcat7 restart
cd poi_fusion_engine2/services
cp fic2_fe_inquiry_valencia.war /var/lib/tomcat7/webapps/


echo "You can test the FE in the URL http://<ip_server>:8080/fev2/citysdk/test/index"


