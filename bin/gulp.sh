#!/usr/bin/env bash
#
# Executa o comando gulp do para execução de tarefas programadas em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

echo "Running inside 'dsc-node' container:"
#docker run -it -u `id -u $USER` --rm \
#-v /etc/passwd:/etc/passwd \
#-v "/home/$USER:/home/$USER" \
#-v $(pwd):/app \
#dev-node sh \
#-ci "cd /app && gulp $@"

docker run -it -u `id -u $USER` --rm \
-v $(pwd):/app \
dsc-node sh \
-ci "cd /app && gulp $@"
