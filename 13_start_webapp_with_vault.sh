#!/bin/sh
set -o xtrace

#delete sa before creating
kubectl delete serviceaccount webapp-sa
#create webapp-sa
kubectl create serviceaccount webapp-sa


#deleting before creating
kubectl delete -f webapp-with-vault.yaml

#webapp with vault annotations
kubectl apply -f webapp-with-vault.yaml

#Check within Container that PW changes: kubectl exec -it POD -- sh --> cd config --> cat config.ini