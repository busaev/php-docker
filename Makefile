restart: down up

down:
	docker compose down --remove-orphans
up:
	docker compose up -d

sh:
	docker compose exec app bash

build:
	docker compose build
