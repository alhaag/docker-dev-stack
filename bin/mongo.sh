#!/usr/bin/env bash
#
# Executa o comando mongo para acesso ao cli do MongoDB presente no container.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'mongo' container:"
docker exec -it dev-mongo mongo
