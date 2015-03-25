#!/bin/bash

/etc/init.d/postgresql start
/etc/init.d/tomcat7 start
exec tail -f /var/log/tomcat7/catalina.out