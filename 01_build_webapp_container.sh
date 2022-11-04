#!/bin/sh
set -o xtrace

#Building the container for our app locally
cd app
docker build -t lomar92/vault-demo-webapp-k8s:latest .