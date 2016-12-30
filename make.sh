#!/usr/bin/env bash
#
# Funções shellscript auxiliares ao Makefile.
#
# Todas as fuções presentes neste arquivo estão mapeadas no Makefile e podem
# ser executas pelo programa make. Ex $ make build
# Nem todas as opções do Makefile estão neste arquivo. Apenas as que demandam
# maior complexidade.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

#######################################
# Instala funções extras para manipulação de containers no bash do usuário.
# É realizada uma cópia do bashrc antes de realizar a instalação.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Void
#######################################
bashrc ()
{
    if [ ! -f ${HOME}/.bashrc.ori ]; then
        cp conf/.bashrc ${HOME}/.bashrc.ori
        echo "copia de seguranca realizada: ${HOME}/.bashrc.ori"
    fi
    cp conf/.bashrc ${HOME}/.bashrc_docker
    echo "Funcoes adicionais instaladas em: ${HOME}/.bashrc_docker"

    if grep -q "bashrc_docker" ${HOME}/.bashrc; then
        echo "Link jah existe no bashrc"
    else
        echo -e "\n# Funcoes docker\n[ -f ~/.bashrc_docker ] && source ~/.bashrc_docker\n" >> ${HOME}/.bashrc;
        echo "Link adicionado no arquivo: ${HOME}/.bashrc"
    fi
}

#######################################
# Instala funções extras no bash do usuário para manipulação de containers.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Void
#######################################
build ()
{
    # set vars
    local USE_PROXY="$(awk -F "=" '/USE_PROXY/ {print $2}' .env)"
    local PROXY_SERVER="$(awk -F "=" '/PROXY_SERVER/ {print $2}' .env)"
    local PROXY_PORT="$(awk -F "=" '/PROXY_PORT/ {print $2}' .env)"
    local PROXY_USER="$(awk -F "=" '/PROXY_USER/ {print $2}' .env)"
    local PROXY_PASSWD="$(awk -F "=" '/PROXY_PASSWD/ {print $2}' .env)"

    # bild nodejs image from Dockerfile.node
    docker build --force-rm \
        --build-arg use_proxy=${USE_PROXY} \
        --build-arg proxy_server=${PROXY_SERVER} \
        --build-arg proxy_port=${PROXY_PORT} \
        --build-arg proxy_user=${PROXY_USER} \
        --build-arg proxy_passwd=${PROXY_PASSWD} \
        -t nodejs - < Dockerfile.node

    # remove previous images from services
    docker-compose rm -f
    # build services
    docker-compose build --force-rm
}

#
# Main
#######################################
$1 # Executa a funcao chamada