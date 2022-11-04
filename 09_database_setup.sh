#!/bin/sh
set -o xtrace

# Note: This script requires that the VAULT_ADDR, VAULT_TOKEN, and MYSQL_ENDPOINT environment variables be set.
# Example:
export VAULT_ADDR=http://localhost:30000
export VAULT_TOKEN=root
export VAULT_NAMESPACE=dev
export MYSQL_ENDPOINT=mysql:3306


vault secrets enable -path=data_protection/database database
vault secrets enable -path=secret kv-v2

# Configure kv-v2 engine to store static secrets
vault kv put /secret/mysql username=root password=root
#vault kv get /secret/mysql

# Configure the database secrets engine to talk to MySQL
vault write data_protection/database/config/wsmysqldatabase \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(${MYSQL_ENDPOINT})/" \
    allowed_roles="vault-demo-app","vault-demo-app-long" \
    username="root" \
    password="root"

# Rotate root password
#vault write  -force data_protection/database/rotate-root/wsmysqldatabase

# Create a role with a longer TTL
vault write data_protection/database/roles/vault-demo-app-long \
    db_name=wsmysqldatabase \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON my_app.* TO '{{name}}'@'%';" \
    default_ttl="1h" \
    max_ttl="24h"

# Create a role with a shorter TTL
vault write data_protection/database/roles/vault-demo-app \
    db_name=wsmysqldatabase \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON my_app.* TO '{{name}}'@'%';" \
    default_ttl="3m" \
    max_ttl="6m"

#test and generate dynamic username password
vault read data_protection/database/creds/vault-demo-app

echo "Database secret engine with mysql plugin configured "