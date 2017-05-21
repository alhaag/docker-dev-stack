#!/usr/bin/env bash
#
# Realiza o buld de todas as imagens necessarias para os servicos.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

#######################################
# Para todos os containers e remove todas as imagens compiladas por esta
# aplicação.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
clear()
{
    local img_node=$(docker images -q dsc-node 2> /dev/null)
    if [[ "${img_node}" != "" ]]; then
        docker rmi -f ${img_node}
    fi

    local img_php_fpm_56=$(docker images -q dsc-php-fpm-56 2> /dev/null)
    if [[ "${img_php_fpm_56}" != "" ]]; then
        docker rmi -f ${img_php_fpm_56}
    fi

    local img_php_fpm_71=$(docker images -q dsc-php-fpm-71 2> /dev/null)
    if [[ "${img_php_fpm_71}" != "" ]]; then
        docker rmi -f ${img_php_fpm_71}
    fi

    local img_openresty=$(docker images -q dsc-openresty 2> /dev/null)
    if [[ "${img_openresty}" != "" ]]; then
        docker rmi -f ${img_openresty}
    fi

    local img_nginx=$(docker images -q dsc-nginx 2> /dev/null)
    if [[ "${img_nginx}" != "" ]]; then
        docker rmi -f ${img_nginx}
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
#   None
#######################################
build()
{
    # set vars
    local USE_PROXY="$(awk -F "=" '/USE_PROXY/ {print $2}' .env)"
    local PROXY_SERVER="$(awk -F "=" '/PROXY_SERVER/ {print $2}' .env)"
    local PROXY_PORT="$(awk -F "=" '/PROXY_PORT/ {print $2}' .env)"
    local PROXY_USER="$(awk -F "=" '/PROXY_USER/ {print $2}' .env)"
    local PROXY_PASSWD="$(awk -F "=" '/PROXY_PASSWD/ {print $2}' .env)"

    # bild 'dsc-node' image from Dockerfile.node
    docker build --force-rm \
        --build-arg use_proxy=${USE_PROXY} \
        --build-arg proxy_server=${PROXY_SERVER} \
        --build-arg proxy_port=${PROXY_PORT} \
        --build-arg proxy_user=${PROXY_USER} \
        --build-arg proxy_passwd=${PROXY_PASSWD} \
        -t dsc-node - < Dockerfile.node

    # build 'dsc-php-fpm:5.6' image from Dockerfile.php5.6-fpm
    docker build --force-rm -t dsc-php-fpm-56 - < Dockerfile.php5.6-fpm

    # build 'dsc-php-fpm:7.1' image from Dockerfile.php7.1-fpm
    docker build --force-rm -t dsc-php-fpm-71 - < Dockerfile.php7.1-fpm

    # build 'dsc-openresty' image from Dockerfile.php7.1-fpm
    docker build --force-rm -t dsc-openresty - < Dockerfile.openresty

    # build 'dsc-nginx' image from Dockerfile.nginx
    docker build --force-rm -t dsc-nginx - < Dockerfile.nginx
}

#
# Main
#######################################
clear
build

exit 0