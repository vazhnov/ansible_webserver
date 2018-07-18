# Конфигурация Ansible для настройки Debian/Ubuntu в качестве web-сервера

Находится в стадии разработки.

You can select different roles for you servers (Nginx, Apache, uwsgi, MySQL, PostgreSQL) and list with websites.
Примеры в репозитории.

## Первые шаги

### Ansible

Установите Ansible на ваш рабочий компьютер (на сервер не нужно) из репозитория:

```bash
sudo apt-get install ansible
```

Если не устраивает версия Ansible, можно подключить [ppa:ansible/ansible](https://launchpad.net/~ansible/+archive/ubuntu/ansible) или [ppa:ansible/ansible-1.9](https://launchpad.net/~ansible/+archive/ubuntu/ansible-1.9).

### SSH

Настройте `~/.ssh/config`, чтобы был доступ к серверу просто по команде `ssh имя_сервера`, например:

```text
Host srv01.example.com
 Port 2222
 User myuser
```

### Получить код этого проекта

Копируем к себе весь код, если ещё не сделали это ранее:

```bash
git clone "https://gitlab.com/vazhnov/ansible_webserver.git"
```

### Учётные записи пользователей

Создание учётных записей с паролями не поддерживается, используйте SSH ключи и беспарольный sudo.

* Создайте файл `group_vars/all/users.yml` приблизительно такого содержания:

```yaml
# File: group_vars/all/users.yml
---
users:
  john_scott:
    comment: 'John Scott'
    groups: 'adm,sudo,no_passwd_sudo'
  first_last:
    comment: 'First Last'
    groups: 'adm,sudo,no_passwd_sudo'
```

* Создайте для пользователей директории вида: `roles/user_access/files/replace_files/john_scott`, файлы из них будут заменять файлы на удалённых хостах при каждом применении конфигурации Ansible.
* В директориях для файлов пользователей положите файлы `.ssh/authorized_keys` с публичными ключами SSH.
* Создайте для пользователей директории вида: `roles/user_access/files/first_files/john_scott`, файлы из них будут скопированы на удалённый хост, только если там ещё нет такого. Удобно, например, хранить `.vimrc`, `.config/mc/hotlist` и т.п.

### Список серверов

* В файл `inventory/production/static` запишите имена серверов (лучше использовать FQDN). Одна строка = один сервер.
* В `host_vars` создайте папку с именем сервера;
* В ней создайте .yml файл со списком ролей для сервера, пример в [host\_vars/srv01.example.com/roles.yml](https://github.com/vazhnov/ansible_webserver/blob/master/host_vars/srv01.example.com/roles.yml).

### Список сайтов

* в `host_vars/имя_сервера/` создайте .yml файл со списком `all_websites`. Пример есть в [host\_vars/srv01.example.com/all\_websites.yml](https://github.com/vazhnov/ansible_webserver/blob/master/host_vars/srv01.example.com/all_websites.yml).

### Применяем

В первый раз, чтобы установить Python:

```shell
ansible-playbook -i inventory/production pre_install.yml --limit=srv01.example.com
```

Если для sudo нужен пароль, добавьте опцию `--ask-sudo-pass`.

Применяем роли:

```shell
ansible-playbook -i inventory/production websites_roles.yml --limit=srv01.example.com
```

## Подробная настройка

### Словарь all\_websites

* `state` — absent/present, по умолчанию present, в случае если будет выбран absent, то удалятся symlink'и на конфигурации и сервисам будет отправлен сигнал reload;

#### Роль user\_access

Опции:

* `no_passwd_sudo` — если No/False, то файл `/etc/sudoers.d/no_passwd_sudo` не будет скопирован (по умолчанию = Yes);

#### Роль nginx

Опции:

* `template` — имя шаблона из [roles/nginx/templates/](https://github.com/vazhnov/ansible_webserver/tree/master/roles/nginx/templates/);
* `root_options` — список;
* `limit_req` — bool, default = Yes;
* `limit_req_size` — default = 2m;
* `limit_req_rate` — default = 3r/s;
* `limit_req_burst` — default = 10;

#### Роль apache

Опции:

* `template` — имя шаблона из [roles/apache/templates/](https://github.com/vazhnov/ansible_webserver/tree/master/roles/apache/templates/);
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

* `requirements_file` — список пакетов pip;

## Адаптация

В каждой роли можно добавить задачи с именем сервера, либо с версией ОС, используется «with\_first\_found»:

* `"name_{{ inventory_hostname }}.yml"`
* `"os_{{ ansible_distribution }}_{{ ansible_distribution_version }}.yml"`
* `"os_{{ ansible_distribution }}_{{ ansible_distribution_major_version }}.yml"`
* `"os_{{ ansible_distribution }}.yml"`
* `empty.yml`

Свои шаблоны в ролях рекомендуется называть my\_*, так они будут автоматически попадать под правила gitignore.

## Полезные команды

* `git ls-files --ignored --exclude-standard` — посмотреть список игнорируемых файлов;
* `ansible -i inventory/production srv01.example.com -m raw -a "sudo apt-get install -y python-minimal"` — установить Python2;

## Полезные переменные для отдельных серверов/групп

* `apt_proxy: "http://example.com:3142"` — если задана, будет создан файл `/etc/apt/apt.conf.d/000apt-cacher-ng-proxy`;
* `ntp_list` — если задана, будет сформирован файл `/etc/ntp.conf` с указанным списком серверов;

## Известные ограничения

* Создание учётных записей с паролями не поддерживается, используйте SSH ключи и беспарольный sudo;
* Одна учётная запись пользователя = один web-сайт;
* For first server configuring and restoring websites from backups, not for everyday updating packeges in pip

## Авторское право

Весь контент этого репозитория распространяется под свободной лицензией MIT.
