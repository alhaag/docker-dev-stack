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

# Global vars
HELP_MSG="
Uso: $(basename "$0") [OPÇÕES]

OPÇÕES:
i,   install      Instala funções de atalho no terminal do usuário atual para manipulação dos containers
b,   build        Baixa imagensa base caso necessŕio e compila os containers
up,  start        Inicia os serviços
s    stop         Para os serviços em execução
rm,  remove       Para os containers e remove imagens compiladas
rmd, remove-data  Remove dados armazenados pelos SGBDs

h,   help         Obtem ajuda
V,   version      Mostra a versão
"
install=0
build=0
start=0
stop=0
remove=0
remove_data=0
help=0
version=0

# TODO: implementar metodo 'cfg_validate' para validar configurações de .env

start()
{
    docker-compose up -d
}

stop()
{
    docker-compose stop
}

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
    # para sevicos em execucao
    docker-compose stop
    # remove imagens geradas pelo composer
    docker-compose rm -f

    # remove apenas as imagens geradas por esta aplicacao (img base sao preservadas)
    local img_composer=$(docker images -q dev-composer 2> /dev/null)
    if [[ "${img_composer}" != "" ]]; then
        docker rmi -f ${img_composer}
    fi

    local img_node=$(docker images -q dev-node 2> /dev/null)
    if [[ "${img_node}" != "" ]]; then
        docker rmi -f ${img_node}
    fi

    local img_php_fpm=$(docker images -q dev-php-fpm 2> /dev/null)
    if [[ "${img_php_fpm}" != "" ]]; then
        docker rmi -f ${img_php_fpm}
    fi

    local img_mysql=$(docker images -q dev-mysql 2> /dev/null)
    if [[ "${img_mysql}" != "" ]]; then
        docker rmi -f ${img_mysql}
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
build ()
{
    clear

    # set vars
    local USE_PROXY="$(awk -F "=" '/USE_PROXY/ {print $2}' .env)"
    local PROXY_SERVER="$(awk -F "=" '/PROXY_SERVER/ {print $2}' .env)"
    local PROXY_PORT="$(awk -F "=" '/PROXY_PORT/ {print $2}' .env)"
    local PROXY_USER="$(awk -F "=" '/PROXY_USER/ {print $2}' .env)"
    local PROXY_PASSWD="$(awk -F "=" '/PROXY_PASSWD/ {print $2}' .env)"

    # bild 'node' image from Dockerfile.node
    docker build --force-rm \
        --build-arg use_proxy=${USE_PROXY} \
        --build-arg proxy_server=${PROXY_SERVER} \
        --build-arg proxy_port=${PROXY_PORT} \
        --build-arg proxy_user=${PROXY_USER} \
        --build-arg proxy_passwd=${PROXY_PASSWD} \
        -t dev-node - < Dockerfile.node

    # build 'composer' image
    docker build --force-rm -t dev-composer - < Dockerfile.composer

    # build 'mysql' form Dockerfile.mysql
    local MYSQL_VERSION="$(awk -F "=" '/MYSQL_VERSION/ {print $2}' .env)"
    cat Dockerfile.mysql | sed "s/{{version}}/${MYSQL_VERSION}/" | docker build -t dev-mysql:${MYSQL_VERSION} -

    # build services
    docker-compose build --force-rm
}

help()
{
    echo -e "$HELP_MSG"
    exit 0
}

#
# Main
#######################################

# tratamento das entradas da linha de comando
while test -n "$1"
do
    case "$1" in
        i   | install     ) install=1     ;;
        b   | build       ) build=1       ;;
        up  | start       ) start=1       ;;
        s   | stop        ) stop=1        ;;
        rm  | remove      ) remove=1      ;;
        rmd | remove-data ) remove_data=1 ;;
        h   | help        ) help=1        ;;
        V   | version     ) version=1     ;;
        *                    )
            echo "Opção inválida: $1"
            exit 1
    esac
    shift
done

#MYSQL_VERSION="$(awk -F "=" '/MYSQL_VERSION/ {print $2}' .env)"
#echo "$MYSQL_VERSION"
if [ $build == 1 ]; then
    build
fi

if [ $start == 1 ]; then
    start
fi

if [ $stop == 1 ]; then
    stop
fi

# realiza chamas as funções de acordo com os opções
if [ $help == 1 ]; then
    help
fi

exit 0
