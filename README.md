Ansible playbooks for configuring Debian/Ubuntu web server.

Not ready yet!!!

## Documentation

* [README\_RU](README_RU.md)
* [README\_EN](README_EN.md)


You can select different roles for you servers (Nginx, Apache, uwsgi, MySQL, PostgreSQL) and list with websites.
Examples are in repository.

## Useful host/group variables

* `apt_proxy: "http://example.com:3142"` — if defined, create file `/etc/apt/apt.conf.d/000apt-cacher-ng-proxy`;
* `ntp_list` — if defined,

## Known limitations

* One user = one website
* For first server configuring and restoring websites from backups, not for everyday updating packeges in pip

## Copyright

Distributed under MIT license.
