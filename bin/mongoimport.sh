#!/usr/bin/env bash
#
# Executa o comando mongoimport para importação de dados para o MongoDB.
# Exemplos de uso:
#   $ mongoimport --jsonArray --db dsc-api-address --collection Users --drop < users.json
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'mongo' container:"
docker exec -i dsc-mongo mongoimport $@
