PROJECT=flaskmysql
MYSQL_PASSWORD=passw0rd
COMPOSE=docker-compose --project=${PROJECT}

all: vault-up db-up db-wait db-init vault-init app-up

down: vault-revoke
	${COMPOSE} down

## Database

db-up:
	${COMPOSE} up -d database

db-reload:
	${COMPOSE} up -d --force-recreate database

db-down: vault-revoke
	${COMPOSE} down database

db-wait:
	docker exec ${PROJECT}_database_1 /bin/bash -c "while ! mysqladmin ping --password=${MYSQL_PASSWORD}; do sleep 5; done"
	sleep 10

db-init:
	docker exec ${PROJECT}_database_1 /bin/bash -c "mysql -uroot --password=${MYSQL_PASSWORD} < /opt/initdb.sql"

db-describe:
	docker exec ${PROJECT}_database_1 mysql -uroot --password=${MYSQL_PASSWORD} -D VaultDemo -e 'desc todolist'

db-select:
	docker exec ${PROJECT}_database_1 mysql -uroot --password=${MYSQL_PASSWORD} -D VaultDemo -e 'select * from todolist'

db-users:
	docker exec ${PROJECT}_database_1 mysql -uroot --password=${MYSQL_PASSWORD} -e 'select User from mysql.user'

db-shell:
	docker exec -it ${PROJECT}_database_1 mysql -uroot --password=${MYSQL_PASSWORD} -D VaultDemo

db-bash:
	docker exec -it ${PROJECT}_database_1 /bin/bash

db-logs:
	${COMPOSE} logs -f database

db-query-logs:
	docker exec ${PROJECT}_database_1 tail -f /var/log/mysql/query.log

## App

app-up: vault-token
	${COMPOSE} up -d app

app-recreate: vault-revoke vault-token
	${COMPOSE} stop app
	${COMPOSE} up -d app

app-build:
	${COMPOSE} build app

app-reload: app-build app-up

app-down: vault-revoke
	${COMPOSE} down app

app-bash:
	docker exec -it ${PROJECT}_app_1 /bin/bash

app-logs:
	${COMPOSE} logs -f app

## Vault

vault-up:
	${COMPOSE} up -d vault

vault-recreate:
	${COMPOSE} up -d --force-recreate vault

vault-build:
	${COMPOSE} build vault

vault-reload: vault-build vault-up

vault-down: vault-revoke
	${COMPOSE} down vault

vault-bash:
	docker exec -it ${PROJECT}_vault_1 /bin/sh

vault-logs:
	${COMPOSE} logs -f vault

vault-init:
	docker exec ${PROJECT}_vault_1 vault mount mysql
	docker exec ${PROJECT}_vault_1 vault write mysql/config/connection connection_url="root:${MYSQL_PASSWORD}@tcp(database:3306)/"
	docker exec ${PROJECT}_vault_1 vault write mysql/config/lease lease=1h lease_max=24h
	docker exec ${PROJECT}_vault_1 vault write mysql/roles/flaskapp sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT INSERT, SELECT ON VaultDemo.todolist TO '{{name}}'@'%';"

vault-token:
	docker exec ${PROJECT}_vault_1 vault token-create --format=json > flaskapp/vault.token

vault-revoke:
ifeq ($(wildcard flaskapp/vault.token),)
	echo "Token doesn't exist, skipping revoke..."
else
	jq -r .auth.client_token flaskapp/vault.token | xargs docker exec ${PROJECT}_vault_1 vault token-revoke
	rm flaskapp/vault.token
endif

vault-seal:
	docker exec ${PROJECT}_vault_1 vault seal

vault-unseal:
	docker exec -it ${PROJECT}_vault_1 vault unseal

vault-status:
	docker exec ${PROJECT}_vault_1 vault status
