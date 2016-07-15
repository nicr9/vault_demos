PROJECT=vaultdemo
MYSQL_PASSWORD=passw0rd
COMPOSE=docker-compose --project=${PROJECT}

all: db-up db-wait db-init app-up

down:
	${COMPOSE} down

## Database

db-up:
	${COMPOSE} up -d database

db-reload:
	${COMPOSE} up -d --force-recreate database

db-down:
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

db-shell:
	docker exec -it ${PROJECT}_database_1 mysql -uroot --password=${MYSQL_PASSWORD} -D VaultDemo

db-bash:
	docker exec -it ${PROJECT}_database_1 /bin/bash

db-logs:
	${COMPOSE} logs -f database

## App

app-up:
	${COMPOSE} up -d app

app-recreate:
	${COMPOSE} up -d --force-recreate app

app-build:
	${COMPOSE} build app

app-reload: app-build app-up

app-down:
	${COMPOSE} down app

app-bash:
	docker exec -it ${PROJECT}_app_1 /bin/bash

app-logs:
	${COMPOSE} logs -f app
