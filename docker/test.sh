#!/bin/bash

# cd /root/poi_fusion_engine2/services
wget http://$1:$2/fic2_fe_inquiry_valencia/citysdk/categories/search?list=poi -q -O down.json >/dev/null
if diff ./down.json ./down.json >/dev/null ; then
  echo "Test passed OK"
  echo 0
else
  echo "The test json file is not the same as expected"
  echo 1
fi
