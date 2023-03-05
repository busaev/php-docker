restart: down up

down:
	docker compose down --remove-orphans
up:
	docker compose up -d
up-prod:
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d

sh:
	docker compose exec app bash

build:
	docker compose build

stop:
	docker kill $(docker ps -q)
