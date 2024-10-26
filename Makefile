up:
	@docker compose up

upd:
	@docker compose up -d

upstart:
	@make down
	@make up 

down:
	@docker compose down -v
	@rm -rf postgres_1*data/

bbf:
	@docker compose exec -it -u postgres bbf psql bbf


