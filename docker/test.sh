#!/bin/bash

# cd /root/poi_fusion_engine2/services
wget http://$1:$2/fic2_fe_inquiry_valencia/citysdk/categories/search?list=poi -q -O down.json >/dev/null
wget http://$1:$2/fic2_fe_inquiry_valencia/citysdk/down_expexted.json -q -O down_ex.json >/dev/null
if diff ./down_ex.json ./down.json >/dev/null ; then
  echo "Test passed OK"
  echo 0
else
  echo "The test json file is not the same as expected"
  echo 1
fi
