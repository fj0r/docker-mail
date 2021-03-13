#!/bin/sh
set -eux

echo "${EXTERNAL_IP} ${DOMAIN}" >> /etc/hosts
echo "${DOMAIN:-localhost}" >> /etc/mailname

sed -i 's/USER@DOMAIN\.TLD/'"${MASTER}@${DOMAIN}"'/' /etc/postfix/aliases

postalias /etc/postfix/aliases

service postfix start
service dovecot start
service opendkim start

watchexec -p -w /etc/postfix/ -- service postfix restart &
watchexec -p -w /etc/dovecot/ -- service dovecot restart &
watchexec -p -w /etc/opendkim.conf -- service opendkim restart &

wait
