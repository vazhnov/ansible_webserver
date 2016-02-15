Конфигурация Ansible для настройки Debian/Ubuntu в качестве web-сервера.

Находится в стадии разработки.

You can select different roles for you servers (Nginx, Apache, uwsgi, MySQL, PostgreSQL) and list with websites.
Примеры в репозитории.

# Полезные переменные для отдельных серверов/групп

* `apt_proxy: "http://example.com:3142"` — если задана, будет создан файл `/etc/apt/apt.conf.d/000apt-cacher-ng-proxy`;
* `ntp_list` — если задана, будет сформирован файл `/etc/ntp.conf` с указанным списком серверов;

# Известные ограничения

* Одна учётная запись пользователя = один web-сайт;
* For first server configuring and restoring websites from backups, not for everyday updating packeges in pip

# Лицензия

Распространяется под лицензией MIT.
