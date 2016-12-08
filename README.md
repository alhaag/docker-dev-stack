# Docker developer environment

Ambiente completo para desenvolvimento em máquina virtual por meio do containers Docker e Docker Compose.

## Funcionalidades
Prove ambiente de desenvolvimento em CentOS 7 com as seguintes aplicações:
 * PHP-FPM 7.x
 * Nginx
 * MySQL

## Requisitos
 * Docker
 * Docker Compose

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
| MYSQL_ROOT_PASSWORD  | Senha do usuário **root** do MySQL |
| NGINX_HOSTS_CONF     | Díretório que pussui arquivos de configuração de virtualhosts(sites) do nginx |
| WWW_DATA             | Document root onde estão os arquivos dos sites |

Importante: o arquivo **.env.example** não deve ser editado.

Comandos básicos do Docker:
```
$ docker-compose up                           # provisiona os containers (deve ser executato no diretório onde está o arquivo docker-compose.yml)
$ docker ps                                   # listar container em execução
$ sudo docker exec -it <container_name> bash  # acessa o terminal do container
<Ctrl> + d ou exit                            # abandona o terminal
$ docker-compose restart                      # reinicia containers(reboot)
$ docker-compose down                         # desliga containers
$ docker-compose rm                           # destroi containers
```

Específicos desta topologia:
```
## Importar arquivo SQL
$ sudo docker exec -i mysql mysql -uroot -p<root_password> < "db.sql"
```