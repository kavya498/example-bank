#!/bin/bash
t=$PRIVATEIPS
a=($(echo "$t" | tr ',' '\n'))
for IP in "${a[@]}"
do
    curl -X DELETE "https://containers.cloud.ibm.com/global/v1/nlb-dns/clusters/$CLUSTER/host/$HOST/ip/$IP/remove" -H "Authorization: $TOKEN"
done

