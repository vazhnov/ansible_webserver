# How to (ru)

## WordPress

Как быстро развурнуть web-сервер на Ubuntu/Debian с Nginx + Apache + MySQL + Wordpress с помощью Ansible.

Логинимся на сервер по SSH, желательно не от суперпользователя root.

### Установка Ansible на управляющий компьютер

```bash
sudo apt-get update
sudo apt-get --no-install-recommends install software-properties-common # Для add-apt-repository
sudo add-apt-repository ppa:ansible/ansible-2.3
sudo apt-get update
sudo apt-get install ansible
sudo apt-get --no-install-recommends install python-minimal python-apt
```

### Настройка SSH

Настройте `~/.ssh/config`, чтобы был доступ к серверу просто по команде `ssh имя_сервера`, например:

```text
Host srv01.example.com
 Port 2222
 User myuser
```

Проверьте доступ:

```bash
ssh srv01.example.com sudo whoami
```

Вывод должен быть:

```text
root
```

### Клонирование конфигурации Ansible

```bash
mkdir -p ~/git
cd ~/git
git clone git@github.com:vazhnov/ansible_webserver.git
cd ~/git/ansible_webserver/
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

* Создайте файлы вида: `roles/user_access/files/replace_files/john_scott/.ssh/authorized_keys` и т.п. с публичными ключами SSH.

### Список серверов

* В файл `inventory/production/static` запишите имя сервера, которое вы указали в `~/.ssh/config`.
* В директории `host_vars` создайте папку с таким же именем сервера;
* В этой папке создайте файл `roles.yml` со списком ролей для сервера:

```yaml
---
roles:
  - user_access
  - nginx
  - apache
  - php
  - mysql
```

### Список сайтов

* сгенерируйте 16-символьный пароль для БД:

```bash
pwgen -s 16 1
```

* в недавно созданной директории вида `host_vars/имя_сервера/` создайте файл со списком `all_websites.yml`, пропишите в нём ваш DNS сайта и сгенерированный пароль:

```yaml
---
all_websites:
  wordpress.example.com:
    apache:
      template: lamp
    nginx:
      template: lamp
      root_options:
        - client_max_body_size 32m
    # For MySQL, used only first 16 symbols of 'user'
    user: wordpressexamplecom
    db_type: mysql
    mysql:
      password: j3HJywe4Xutx3FudcXd1at
    serveralias:
      - www.wordpress.example.com
```

### Применяем

В первый раз, чтобы установить Python:

```bash
ansible-playbook -i inventory/production pre_install.yml --limit=srv01.example.com
```

Если для sudo нужен пароль, добавьте опцию `--ask-sudo-pass`.

Применяем роли:

```bash
ansible-playbook -i inventory/production websites_roles.yml --limit=srv01.example.com
```

