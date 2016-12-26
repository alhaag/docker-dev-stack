# Docker developer environment

Ambiente completo para desenvolvimento em máquina virtual por meio do containers Docker e Docker Compose.

## Funcionalidades
Prove ambiente de desenvolvimento em CentOS 7 com as seguintes aplicações:
 * PHP-FPM
 * Nginx
 * MySQL
 * Nodejs
   * gulp
   * bower

## Requisitos
 * Docker >= 1.12
 * Docker Compose >= 1.9

Exemplo de instalação do Docker e Docker Compose no Ubuntu:

```
$ sudo curl -sSL https://get.docker.com | sh

$ sudo curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## Utilização
Copiar o arquivo **.env.example** para **.env** e alterar as variáveis de ambiente conforme necessidade.

| Variável             | Descrição                |
|:-------------------- |:------------------------ |
| PHP_VERSION          | Versão do PHP (5.6 ou 7.1) |
| MYSQL_VERSION        | Versão do BD MySQL (5.6, 5.6.35, 5.7 ou latest) |
| MYSQL_DATA           | Diretório onde serão armazenados os dados do MySQL |
| MYSQL_ROOT_PASSWORD  | Senha do usuário **root** do MySQL |
| NGINX_HOSTS_CONF     | Díretório que pussui arquivos de configuração de virtualhosts(sites) do nginx |
| WWW_DATA             | Document root onde estão os arquivos dos sites |

Importante: o arquivo **.env.example** serve apenas para exemplo e não deve ser editado.

Comandos básicos do Docker:
```
$ docker-compose build                     # baixa as imagens e compila a estrutura de containers
$ docker-compose up                        # provisiona os containers (deve ser executato no diretório onde está o arquivo docker-compose.yml)
$ docker ps                                # listar container em execução
$ docker exec -it <container_name> bash    # acessa o terminal do container (algumas distribuições como alpine possuem apenas **sh**)
$ docker logs -f <container_name>          # observa logs do container
<Ctrl> + d ou exit                         # abandona o terminal
$ docker-compose restart                   # reinicia containers(reboot)
$ docker-compose down                      # desliga containers
$ docker-compose rm                        # destroi containers
```

## Extras
Importar arquivo SQL para o container mysql:
```
$ docker exec -i mysql mysql -uroot -p<root_password> < "db.sql"
```

Executar o gerenciador de pacotes composer PHP (a imagem deste container será baixada por demanda e não esta presente no compose).

**composer install**
```
$ docker run --rm -u $UID -v `pwd`:/app composer/composer install
```

Para executar tarefas com nodejs é necessário primeiramente realizar o build do Dockerfile presente no diretório **nodejs**:
```
$ cd nodejs
$ sudo docker build -t  nodejs .
```

**npm install**
```
$ docker run -it -u `id -u $USER` --rm \
    -v /etc/passwd:/etc/passwd \
    -v "/home/$("`echo $USER`"):/home/$("`echo $USER`")" \
    -v $(pwd):/app \
    nodejs bash \
    -ci "cd /app && npm install"
```

**bower install**
```
docker run -it -u `id -u $USER` --rm \
    -v $(pwd):/app \
    -v /var/tmp/bower:/home/$("`echo $USER`")/.bower nodejs \
    /bin/bash \
    -ci "cd /app && bower install \
      --config.interactive=false \
      --config.storage.cache=/home/$("`echo $USER`")/.bower/cache"
```

Dica: para facilitar a utilização podem ser criados funções no arquivo **~/.basrc** para executar as tarefas descritas acima de forma transparente.

**Trecho de exemplo do bashrc:**
```
...

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
...
```

## Bonus

Gerenciamento de containers e imagens por meio de interface gráfica com o cantainer **docker-ui**:
```
$ docker run -d -p 8080:9000 -v /var/run/docker.sock:/docker.sock --name dockerui abh1nav/dockerui:latest -e="/docker.sock"
```

Orquestrando containers por meio de interface gráfica **rancher**:
```
$ docker run -d --restart=unless-stopped -p 8080:8080 rancher/server
```
Mais detalhes em: http://rancher.com/

## TODO

 * Malhorar funções nodejs e npm.