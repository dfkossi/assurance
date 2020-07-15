#!/bin/sh

rm -rf ./cryptogen
mkdir -p cryptogen
chmod 777 cryptogen
cd ./cryptogen
podnames=(back-assurance back-isp1)

for pod in "${podnames[@]}"
do
    POD_NAME="$(kubectl get --field-selector=status.phase=Running --no-headers=true pods -o name | grep ${pod} | awk -F "/" '{print $2}')"
    echo $POD_NAME
    kubectl cp $POD_NAME:/home/node/cryptogen -c backend . 
done