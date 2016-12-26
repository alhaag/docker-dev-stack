
# DOCKER ALIAS FUNCTIONS
# ==============================================================================

# ####################################
# Executa o comando composer do gerenciador de pacotes do PHP em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Paramns:
#   $1 Opções do composer a serem executadas. Ex install ou update
# ####################################
composer() {
    docker run --rm -u $UID -v `pwd`:/app composer/composer "$@"
}

# ####################################
# Executa o comando npm do gerenciador de pacotes do NodeJS em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Paramns:
#   $1 Opções do npm a serem executadas. Ex install
# ####################################
npm() {
    docker run -it -u `id -u $USER` --rm \
    -v /etc/passwd:/etc/passwd \
    -v "/home/$USER:/home/$USER" \
    -v $(pwd):/app \
    nodejs sh \
    -ci "cd /app && npm $@"
}

# ####################################
# Executa o comando bower do gerenciador de pacotes front-end em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Paramns:
#   $1 Opções do bower a serem executadas. Ex install
# ####################################
bower() {
    docker run -it -u `id -u $USER` --rm \
    -v /etc/passwd:/etc/passwd \
    -v "/home/$USER:/home/$USER" \
    -v $(pwd):/app \
    nodejs sh \
    -ci "cd /app && bower $@"
}

# ####################################
# Executa o comando gulp do para execução de tarefas programadas em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Paramns:
#   $1 Opções do gulp a serem executadas. Ex install
# ####################################
gulp() {
    docker run -it -u `id -u $USER` --rm \
    -v /etc/passwd:/etc/passwd \
    -v "/home/$USER:/home/$USER" \
    -v $(pwd):/app \
    nodejs sh \
    -ci "cd /app && gulp $@"
}

# ####################################
# Executa o comando npm do gerenciador de pacotes do NodeJS em um container
# Docker. Os conteúdo do diretório onde o comando é executado é espelhado no
# container para que este tenha acesso ao projeto.
#
# Paramns:
#   $1 Opções do npm a serem executadas. Ex install
# ####################################
mysql() {
    # docker exec -it mysql bash -c 'mysql -uroot -p -e "show databases;"'
    # docker exec -i mysql mysql -uroot -pPASSWD  < "db.sql"
    # docker exec -it mysql mysql $@
    docker exec -i mysql mysql $@
}

export -f composer
export -f npm
export -f bower
export -f gulp
export -f mysql