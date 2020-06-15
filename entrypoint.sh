#!/usr/bin/with-contenv bash
echo >&2 "starting watcher"

sleep 1
cd /etc/openresty

exec watchexec -- reload-nginx 2>&1

$ service postfix restart
$ service dovecot restart