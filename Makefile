include .env

DB_NAME := burch
BASE_PATH := /usr/src/app
ADMIN_USER := postgres
START_FILE := $(BASE_PATH)/src/scripts/deploy.sql
DOCKER_CONTAINER_NAME := app_database

.PHONY: up-d down deploy build clean shell psql file secrets clean-secrets migrate

DOCKER_CONFIG = docker-compose -f docker-compose.yml
MIGRATION_VERSION = ${MIGRATION}

.db_postgres_password:
	@if [ ! -f .db_postgres_password ]; then \
		bash ./src/scripts/bash/generate_secret.sh > .db_postgres_password; \
	fi;

secrets: .db_postgres_password
	@if [ ! -f .db_postgres_password ]; then \
		echo "Secrets generated"; \
	fi;

clean-secrets:
	@rm -rf .db_postgres_password .deployed
	@echo "Secrets cleaned"

up-d: secrets
	@if [ ! -d ./postgres ]; then mkdir -p ./postgres/; fi;
	@echo "Starting containers";
	@$(DOCKER_CONFIG) up -d; 
	@while [ ! -f .deployed ]; do sleep 5; $(MAKE) deploy; done; 
	@docker-compose exec -T $(DOCKER_CONTAINER_NAME) su -c "chmod -R 777 /var/lib/postgresql/data"; 
	@echo "Containers started"; 
	@echo "Application now running at 'postgres://localhost:$(POSTGRES_PORT)/$(DB_NAME)'. To access the application, type 'make psql' or 'make shell'.";

down:
	@echo "Stopping containers"
	@$(DOCKER_CONFIG) down;
	@docker-compose run --rm -T $(DOCKER_CONTAINER_NAME) su -c "chmod -R 777 /var/lib/postgresql/data"
	@echo "Containers stopped";

deploy:
	@echo "Deploying database"
	@if [ ! -f .deployed ] && docker ps --format '{{.Names}}' | grep -q "$(DOCKER_CONTAINER_NAME)"; then \
		sleep 10; \
		docker-compose exec -T $(DOCKER_CONTAINER_NAME) su -c "psql -U postgres -d $(DB_NAME) -f $(START_FILE)" postgres; \
		docker-compose exec -T $(DOCKER_CONTAINER_NAME) su -c "chmod -R 777 /var/lib/postgresql/data"; \
		touch .deployed; \
	fi
	@echo "Database deployed"

build:
	@echo "Building containers"
	@$(DOCKER_CONFIG) build
	@echo "Containers built"

clean: down
	@echo "Cleaning containers"
	@$(DOCKER_CONFIG) down -v
	@rm -rf ./postgres/
	$(MAKE) clean-secrets
	@echo "Containers cleaned"

shell:
	@$(DOCKER_CONFIG) exec $(DOCKER_CONTAINER_NAME) /bin/bash

psql:
	@$(DOCKER_CONFIG) exec $(DOCKER_CONTAINER_NAME) su -c \
		"psql $(DB_NAME)" postgres

file:
	@$(DOCKER_CONFIG) exec $(DOCKER_CONTAINER_NAME) su -c \
		"psql -d $(DB_NAME) -f $(BASE_PATH)/$(FILE)" postgres

migrate:
	@$(DOCKER_CONFIG) exec $(DOCKER_CONTAINER_NAME) su -c \
		"psql -U $(ADMIN_USER) -d $(DB_NAME) -f $(BASE_PATH)/src/scripts/migrate_$(MIGRATION_VERSION).sql" postgres
