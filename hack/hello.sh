#!/bin/bash

header=$1

PARAMS=""
if [[ $header ]];then
  PARAMS="-H \"lane: test-$header\""
fi

while true; do 
    #resp=$(curl -s "http://172.30.40.52:32583/hello"  -H "lane: test-v1") 
    resp=$(curl -s "http://a6402dfe00a5542b69b8d6a18d9654ae-242407463.us-east-1.elb.amazonaws.com/hello" $PARAMS) 
    provider=$(echo $resp | jq .provider.hostname)
    consumer=$(echo $resp | jq .hostname);
    echo "$consumer --> $provider"
    #sleep 0.1
done
