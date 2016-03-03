Конфигурация Ansible для настройки Debian/Ubuntu в качестве web-сервера.

Находится в стадии разработки.

You can select different roles for you servers (Nginx, Apache, uwsgi, MySQL, PostgreSQL) and list with websites.
Примеры в репозитории.

## Первые шаги

### SSH

Настройте `~/.ssh/config`.

### Учётные записи пользователей

Создание учётних записей с паролями не поддерживается, используйте SSH ключи и беспарльный sudo.

* Создайте файл `group_vars/all/users.yml` приблизительно такого содержания:

```yaml
# File: group_vars/all/users.yml
---
users:
  john_scott:
    comment: 'John Scott'
    groups: 'sudo,adm'
  first_last:
    comment: 'First Last'
    groups: 'sudo,adm'
```

* Создайте для пользователей директории вида: `roles/user_access/files/replace_files/john_scott`, файлы из них будут заменять файлы на удалённых хостах при каждом применении конфигурации Ansible.
* В директориях для файлов пользователей положите файлы `.ssh/authorized_keys` с публичными ключами SSH.
* Создайте для пользователей директории вида: `roles/user_access/files/first_files/john_scott`, файлы из них будут скопированы на удалённый хост, только если там ещё нет такого. Удобно, например, хранить `.vimrc`, `.config/mc/hotlist` и т.п.

### Список сайтов

* В `host_vars` создайте папку с именем сервера (рекомендуется использовать FQDN);
* В ней создайте .yml файл со списком ролей для сервера, пример в [host_vars/srv01.example.com/roles.yml](https://github.com/vazhnov/ansible_webserver/blob/master/host_vars/srv01.example.com/roles.yml).
* Также создайте .yml файл со списком `all_websites`. Пример есть в [host_vars/srv01.example.com/all_websites.yml](https://github.com/vazhnov/ansible_webserver/blob/master/host_vars/srv01.example.com/all_websites.yml).

### Применяем

```shell
ansible-playbook -i inventory/hosts websites_roles.yml --limit=srv01.example.com
```

## Подробная настройка

### Словарь all_websites

* `state` — absent/present, по умолчанию present, в случае если будет выбран absent, то удалятся symlink'и на конфигурации и сервисам будет отправлен сигнал reload;

#### Роль nginx

Опции:
* `root_options` — список;
* `limit_req` — bool, default = Yes;
* `limit_req_size` — default = 2m;
* `limit_req_rate` — default = 3r/s;
* `limit_req_burst` — default = 10;

#### Роль apache

Опции:
* `php_admin_value` — список;

#### Роль postgresql

Опции:
* `backup_path` — если задан, то при создании БД для сайта, будет загружен дамп с локальной машины;

#### Роль mysql

Опции:
* `backup_path` — если задан, то при создании БД для сайта, будет загружен дамп с локальной машины;
* `password` — пароль на MySQL;

#### Роль pip

Опции:
* `requirements_file` — список;

## Полезные команды

* `git ls-files --ignored --exclude-standard` — посмотреть список игнорируемых файлов;
* `ansible -i inventory/hosts srv01.example.com -m raw -a "sudo apt-get install -y python-minimal"` — установить Python2;

## Полезные переменные для отдельных серверов/групп

* `apt_proxy: "http://example.com:3142"` — если задана, будет создан файл `/etc/apt/apt.conf.d/000apt-cacher-ng-proxy`;
* `ntp_list` — если задана, будет сформирован файл `/etc/ntp.conf` с указанным списком серверов;

## Известные ограничения

* Одна учётная запись пользователя = один web-сайт;
* For first server configuring and restoring websites from backups, not for everyday updating packeges in pip

## Лицензия

Распространяется под лицензией MIT.
