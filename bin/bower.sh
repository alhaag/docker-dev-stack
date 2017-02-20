#!/usr/bin/env bash
#
# Executa o comando bower do gerenciador de pacotes front-end em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'dev-node' container:"
docker run -it -u `id -u $USER` --rm \
-v /etc/passwd:/etc/passwd \
-v "/home/$USER:/home/$USER" \
-v $(pwd):/app \
dev-node sh \
-ci "cd /app && bower $@"