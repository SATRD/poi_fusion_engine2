#!/bin/bash

cd /root/poi_fusion_engine2/services
wget http://172.17.0.2:8080/fic2_fe_inquiry_valencia/citysdk/categories/search?list=poi -q -O down.json >/dev/null
if diff ./down.json ./down.json >/dev/null ; then
  echo 0
else
  echo 1
fi

