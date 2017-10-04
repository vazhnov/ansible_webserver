# How to (ru)

## WordPress

Как быстро развурнуть web-сервер на Ubuntu/Debian с Nginx + Apache + MySQL + Wordpress с помощью Ansible.

Логинимся на сервер по SSH, желательно не от суперпользователя root.

### Установка Ansible на управляющий компьютер

```bash
sudo apt-get update
sudo apt-get --no-install-recommends install software-properties-common # Для add-apt-repository
sudo add-apt-repository ppa:ansible/ansible-2.3
sudo apt-get --no-install-recommends install python-minimal python-apt
sudo apt-get update
sudo apt-get install ansible
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

