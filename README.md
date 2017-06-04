# Docker environment

Ambiente completo para desenvolvimento e produção em containers Docker e Docker Compose para abstração da inicialização dos serviços.

Possui também a funcionalidade de incluir atalhos no **bash**(terminal interpretador de comandos) para facilitar a
execução de comandos presentes nos containers, diretamente no terminal do host hospedeiro. Isso permite executar alguns
comandos como **npm, mysql, etc** de forma transparente e fora do container.

## Funcionalidades

Serviços e ferramentas disponibilizadas:

 * PHP-FPM 5.6
 * PHP-FPM 7.1
 * Nginx (Reverse proxy)
 * Openresty (API Authorization)
 * MySQL
 * MongoDB
 * Nodejs
   * gulp
   * bower
   * polymer-cli
   * Nodemon

## Requisitos

 * Docker >= 17
 * Docker Compose >= 1.13

Exemplo de instalação do Docker e Docker Compose no Ubuntu:

```
$ sudo curl -sSL https://get.docker.com | sh

$ sudo curl -L "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## Utilização

Copiar o arquivo **.env.example** para **.env** e alterar as variáveis de ambiente conforme necessidade.

| Variável             | Descrição                                        |
|:-------------------- |:------------------------------------------------ |
| TZ                   | Time zone para sincronização entre os containers |
| MYSQL_DATA           | Diretório onde serão armazenados os dados do MySQL |
| MYSQL_ROOT_PASSWORD  | Senha do usuário **root** do MySQL |
| MONGO_DATA           | Diretório onde serão armazenados os dados do MongoDB |
| NGINX_HOSTS_CONF     | Díretório que pussui arquivos de configuração de virtualhosts(sites) do nginx que serão disponibilizados na borda, portas 80 e 443 |
| JWT_SECRET           | Segredo para geração e verificação do JWT de autorização das APIs |
| OPENRESTY_NGINX_CONF | Localização do arquivo nginx.conf do Nginx do Openresty |
| OPENRESTY_HOSTS_CONF | Virtual hosts do Openresty com a descrição das rotas das APIs e esquemas de autorizacao |
| WWW_DATA             | Document root onde estão os arquivos dos sites |
| USE_PROXY            | Indica se a conexão com a internet utiliza proxy (true ou false) |
| PROXY_SERVER         | Endereço IP ou hostname do servidor proxy caso necessário |
| PROXY_PORT           | Porta do servidor de proxy caso necessário |
| PROXY_USER           | Usuário do servidor proxy caso necessário |
| PROXY_PASSWD         | Senha do servidor proxy caso necessário |

Importante: o arquivo **.env.example** serve apenas para exemplo e não deve ser editado.

A configuração de proxy realizada nas variáveis de ambiente é para consumo dos containers.
Para que o Docker utilize proxy é necessário realizar configurações adicionais conforme documentação oficial:

https://docs.docker.com/engine/admin/systemd/#/http-proxy


### Build das imagens

Antes de subir o ambiente é necessário possuir todas as imagens compiladas. Para isso execute:
```
$ ./build-images.sh
```

### Iniciar um ambiente

Desenvolvimento:
```
$ docker-compose -f stack-dev.yml up -d
```

Producao:
```
$ docker-compose -f stack-prd.yml up -d
```

### Parar serviços
```
$ docker-compose -f stack-${env}.yml stop
```

### Remover serviços
```
$ docker-compose -f stack-${env}.yml rm -f
```

### Reiniciar um serviço específico
```
$ docker-compose -f stack-${env}.yml restart $service_name
```

### Parar um serviço específico
```
$ docker-compose -f stack-${env}.yml stop $service_name
```

### Logs de um stack
```
$ docker-compose -f stack-${env}.yml logs -f
```

### outros
env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy --compose-file stack-dev.yml dev

docker service ls
docker service logs -f $service_id

docker stack rm $stack_name

sudo journalctl -fu docker.service

docker stats $(docker ps --format={{.Names}})

## TODO

 * Criar container Redis.
