# MySQL Data

Diretório sugerido para armazenamento de dados do MySQL.

Observe que os usuários em sistemas host com SELinux habilitado podem ver problemas de acesso.

A solução atual é atribuir o tipo de diretiva SELinux relevante ao novo diretório de dados para que o container tenha permissão para acessá-lo:

```
$ chcon -Rt svirt_sandbox_file_t /path/to/mysql-data
```
