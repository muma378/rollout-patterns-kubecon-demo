#!/bin/bash

header=$1

PARAMS=""
if [[ $header ]];then
  PARAMS="-H \"lane: test-$header\""
fi

while true; do 
    #resp=$(curl -s "http://172.30.40.52:32583/hello"  -H "lane: test-v1") 
    resp=$(curl -s "http://172.30.40.52:32490/hello" $PARAMS) 
    provider=$(echo $resp | jq .provider.hostname)
    consumer=$(echo $resp | jq .hostname);
    echo "$consumer --> $provider"
    #sleep 0.1
done
