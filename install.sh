#!/usr/bin/env bash
#
# Script de instação.
#
# Instala o programabase 'dev-stack' mais funções adicionais no shell
# do usuário caso solicitado na instalação para execução de rotinas corriqueiras
# de forma containerizada.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

# Global vars
PWD=`pwd`
bin_path="/usr/local/bin"
install_bash_functions=1

#######################################
# Seta variaveis de instação de acordo com o ambiente e SO mais questões
# solicitadas ao usuário caso necessário.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
set_vars ()
{
    question="Instalar funções adicionais para execução containerizada dos comandos
    composer, npm, gulp, bower, mysql, mongo e mongoimport? [S/N]"
    while true; do
        read -p "$question" yn
        case $yn in
            [Ss]* ) break;;
            [Nn]* ) install_bash_functions=0; break;;
            * ) echo -e "\nPor favor, responda S ou N!\n";;
        esac
    done

    #shell=$(ps | grep `echo $$` | awk '{ print $4 }')

}

#######################################
# Valida as opções selecionadas pelo usuário e informações obtidas do ambiente.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
validate ()
{
    if [ ! -d $bin_path ]; then
        echo "Diretório de binarios não existe"
        exit 1
    fi
}

#######################################
# Instala funções extras para manipulação de containers no bash do usuário.
# É realizada uma cópia do bashrc antes de realizar a instalação.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
install_extra_functions ()
{
    if [ $install_bash_functions == 1 ]; then
        ln -s ${PWD}/bin/bower.sh ${bin_path}/bower
        ln -s ${PWD}/bin/composer.sh ${bin_path}/composer
        ln -s ${PWD}/bin/gulp.sh ${bin_path}/gulp
        ln -s ${PWD}/bin/mongo.sh ${bin_path}/mongo
        ln -s ${PWD}/bin/mongoimport.sh ${bin_path}/mongoimport
        ln -s ${PWD}/bin/mysql.sh ${bin_path}/mysql
        ln -s ${PWD}/bin/npm.sh ${bin_path}/npm
        chmod +x ${bin_path}/bower
        chmod +x ${bin_path}/composer
        chmod +x ${bin_path}/gulp
        chmod +x ${bin_path}/mongo
        chmod +x ${bin_path}/mongoimport
        chmod +x ${bin_path}/mysql
        chmod +x ${bin_path}/npm
        echo "Funções de atalho à comandos containerizados instaladas em: ${bin_path}"
    fi
}

#######################################
# Instala o programa padrão 'dev-stack' por meio de link.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
install_bin ()
{
    ln -s ${PWD}/dev-stack.sh ${bin_path}/dev-stack
}

#
# Main
#######################################
# obtem informações para instalação
# pergunta se o usuário deseja instalar funçlões adicionais
set_vars
# valida todos os parametros
#validate
# instala binario principal
#install_bin
# instala/atualiza funçoes adicionais caso solicitado
install_extra_functions
