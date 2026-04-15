.PHONY: start stop down logs migrate enter-api build build-client clean

start:
	docker compose up -d

stop:
	docker compose stop

down:
	docker compose down

logs:
	docker compose logs -f

enter-api:
	docker compose exec api bash

build:
	docker compose build

clean:
	docker compose down -v --rmi local
