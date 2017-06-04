#!/usr/bin/env bash
#
# Instala funções auxiliares baseadas em containers.
#
# Autor: Andre Luiz Haag
# See: https://google.github.io/styleguide/shell.xml

# Global vars
PWD=`pwd`
bin_path="/usr/local/bin"

#######################################
# Instala funções extras para manipulação de containers no bash do usuário.
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
    # ln -sf ${PWD}/bin/bower.sh ${bin_path}/bower
    ln -sf ${PWD}/bin/composer.sh ${bin_path}/composer
    # ln -sf ${PWD}/bin/gulp.sh ${bin_path}/gulp
    ln -sf ${PWD}/bin/mongo.sh ${bin_path}/mongo
    ln -sf ${PWD}/bin/mongoimport.sh ${bin_path}/mongoimport
    ln -sf ${PWD}/bin/mysql.sh ${bin_path}/mysql
    # ln -sf ${PWD}/bin/npm.sh ${bin_path}/npm
    #chmod +x ${bin_path}/bower
    chmod +x ${bin_path}/composer
    # chmod +x ${bin_path}/gulp
    chmod +x ${bin_path}/mongo
    chmod +x ${bin_path}/mongoimport
    chmod +x ${bin_path}/mysql
    # chmod +x ${bin_path}/npm
    echo "Funções de atalho à comandos containerizados instaladas em: ${bin_path}"
}

#
# Main
#######################################
install_extra_functions

exit 0