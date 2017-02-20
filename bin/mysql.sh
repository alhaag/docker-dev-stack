#!/usr/bin/env bash
#
# Executa o comando mysql do container para execução de comandos e importação de
# bases.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'dev-mysql' container:"
# docker exec -it mysql bash -c 'mysql -uroot -p -e "show databases;"'
# docker exec -i mysql mysql -uroot -pPASSWD  < "db.sql"
docker exec -i dev-mysql mysql $@