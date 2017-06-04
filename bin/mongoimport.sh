#!/usr/bin/env bash
#
# Executa o comando mongoimport para importação de dados para o MongoDB.
# Exemplos de uso:
#   $ mongoimport --jsonArray --db dsc-api-address --collection Users --drop < users.json
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'dev_mongo.1.(dinamicaly_id)' container:"
# docker run -i mongo:latest mongoimport $@
docker exec -i $(docker ps -f 'name=dev_mongo.1' -q) mongoimport $@
