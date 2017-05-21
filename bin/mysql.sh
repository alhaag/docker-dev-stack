#!/usr/bin/env bash
#
# Executa o comando mysql do container para execução de comandos e importação de
# bases.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'mysql:5.6.35' container:"
# docker exec -it mysql bash -c 'mysql -uroot -p -e "show databases;"'
# docker exec -i mysql mysql -uroot -pPASSWD  < "db.sql"
docker exec -i mysql:5.6.35 mysql $@