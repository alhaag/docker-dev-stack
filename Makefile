SHELL := /bin/bash
build:
	@docker build --force-rm -t nodejs - < Dockerfile.node
	@docker-compose rm -f
	@docker-compose build --force-rm

up:
	@docker-compose up

stop:
	@docker-compose stop