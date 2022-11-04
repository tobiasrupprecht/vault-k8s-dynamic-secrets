#!/bin/sh
set -o xtrace

kubectl delete -f configmap.yaml
kubectl delete -f webapp.yaml



helm delete mysql
helm delete vault
kubectl delete serviceaccount webapp-sa
kubectl delete sa vault-auth



kubectl get pods mysql-client -o yaml mysql-client.yaml
kubectl delete -f mysql.client.yaml
kubectl delete pvc data-mysql-0
rm mysql-client.yaml


kubectl delete -f configmap.yaml
kubectl delete -f webapp.yaml
kubectl delete -f webapp-with-vault.yaml
kubectl delete -f webapp-with-vault-static.yaml
kubectl delete serviceaccount webapp-sa