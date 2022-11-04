#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:30000
export VAULT_TOKEN=root

vault namespace create dev
