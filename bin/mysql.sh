#!/usr/bin/env bash
#
# Executa o comando mysql do container para execução de comandos e importação de
# bases.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'dev_mysql.1.(dinamicaly_id)' container:"
docker exec -i $(docker ps -f 'name=dev_mysql.1' -q) mysql $@
