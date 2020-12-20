#!/bin/sh
set -eux

echo "${EXTERNAL_IP} ${DOMAIN}" >> /etc/hosts
echo "${DOMAIN}" >> /etc/mailname

sed -i 's/USER@DOMAIN\.TLD/'"${MASTER}@${DOMAIN}"'/' /etc/postfix/aliases

postalias /etc/postfix/aliases

watchexec -r -p -w /etc -- 'service postfix restart 2>&1 \
                           ;service dovecot restart 2>&1
                           ' &
pid="$!"
echo -n "${pid}" > /var/run/watchexec.pid

/usr/sbin/postfix start &
pid="$!"
echo -n "${pid}" > /var/run/postfix.pid

/usr/sbin/dovecot -F &
pid="$!"
echo -n "${pid}" > /var/run/dovecot.pid

opendkim -x /etc/opendkim.conf &
pid="$!"
echo -n "${pid}" > /var/run/opendkim.pid

wait
