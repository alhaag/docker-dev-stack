#!/usr/bin/env bash
#
# Executa o comando composer do gerenciador de pacotes do PHP em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'dev-composer' container:"
docker run --rm -u $UID -v `pwd`:/app dev-composer "$@"