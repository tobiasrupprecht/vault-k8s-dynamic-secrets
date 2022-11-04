#!/bin/sh
set -o xtrace

kubectl delete -f webapp.yaml
kubectl delete -f configmap.yaml
