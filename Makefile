SHELL := /usr/bin/env bash

# install bash functions
bashrc:
	@./make.sh bashrc

# build/rebuild containers
build:
	@./make.sh build

# power on containers
up:
	@docker-compose up

# power off containers
stop:
	@docker-compose stop
